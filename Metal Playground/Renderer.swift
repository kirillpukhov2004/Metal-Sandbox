import MetalKit
import OSLog

class Renderer: NSObject {
    var viewportController: ViewportController

    var metalView: MTKView? {
        didSet {
            guard let metalView = metalView else { return }
            
            metalView.colorPixelFormat = .bgra8Unorm
            metalView.depthStencilPixelFormat = .depth32Float
            metalView.device = device
            metalView.delegate = self
        }
    }

    var device: MTLDevice

    private lazy var commandQueue: MTLCommandQueue = {
        let commandQueue = device.makeCommandQueue()!

        return commandQueue
    }()

    private lazy var mdlVertexDescriptor: MDLVertexDescriptor = {
        let mdlVertexDescriptor = MDLVertexDescriptor()

        mdlVertexDescriptor.attributes[0] = MDLVertexAttribute(
            name: MDLVertexAttributePosition,
            format: .float3,
            offset: 0,
            bufferIndex: 0
        )

        mdlVertexDescriptor.attributes[1] = MDLVertexAttribute(
            name: MDLVertexAttributeNormal,
            format: .float3,
            offset: MemoryLayout<simd_float3>.stride,
            bufferIndex: 0
        )

        mdlVertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: MemoryLayout<simd_float3>.stride * 2)

        return mdlVertexDescriptor
    }()

    private lazy var mtlVertexDescriptor: MTLVertexDescriptor = {
        let mtlVertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlVertexDescriptor)!

        return mtlVertexDescriptor
    }()

    private lazy var renderPipelineState: MTLRenderPipelineState = {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertex_main")!
        let fragmentFunction = library.makeFunction(name: "fragment_main")!

        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float

        renderPipelineDescriptor.vertexDescriptor = mtlVertexDescriptor

        return try! device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
    }()

    private lazy var depthStencilState: MTLDepthStencilState = {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true

        return device.makeDepthStencilState(descriptor: descriptor)!
    }()

    init(viewportController: ViewportController) {
        self.viewportController = viewportController

        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create a Metal device")
        }

        self.device = device

        super.init()
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportController.viewportCamera.update(size: Size(size))
    }
    // TODO: Add viewport shading
    func draw(in view: MTKView) {
        viewportController.viewportCamera.update(deltaTime: 0)

        let scene = viewportController.scene

        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable
        else { return }

        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }

        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setDepthStencilState(depthStencilState)

        scene.meshes.forEach { mesh in
            var uniforms = Uniforms(
                modelMatrix: mesh.transformationMatrix,
                viewMatrix: viewportController.viewportCamera.transformationMatrix,
                projectionMatrix: viewportController.viewportCamera.projectionMatrix
            )

            let mesh = try! MTKMesh(mesh: mesh.mdlMesh, device: device)
            let vertexBuffer = mesh.vertexBuffers[0]

            renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
            renderCommandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)

            for submesh in mesh.submeshes {
                let indexBuffer = submesh.indexBuffer

                renderCommandEncoder.drawIndexedPrimitives(
                    type: submesh.primitiveType,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: indexBuffer.buffer,
                    indexBufferOffset: indexBuffer.offset
                )
            }
        }

        renderCommandEncoder.setFrontFacing(.counterClockwise)
        renderCommandEncoder.setCullMode(.back)
        renderCommandEncoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
