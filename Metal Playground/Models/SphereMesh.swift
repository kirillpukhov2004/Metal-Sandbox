import Foundation
import MetalKit

class SphereMesh: Mesh {
    var id: UUID = UUID()

    @Published var translation: SIMD3<Float> = .zero
    var translationPublisher: Published<SIMD3<Float>>.Publisher { $translation }

    @Published var rotation: SIMD3<Float> = .zero
    var rotationPublisher: Published<SIMD3<Float>>.Publisher { $rotation }

    @Published var scale: SIMD3<Float> = .one
    var scalePublisher: Published<SIMD3<Float>>.Publisher { $scale }

    var transformationMatrix: float4x4 {
        let translationMatrix = float4x4.translationMatrix(tx: translation.x, ty: translation.y, tz: translation.z)

        let rotationMatrix = float4x4.rotationMatrix(rx: rotation.x, ry: rotation.y, rz: rotation.z)

        let scaleMatrix = float4x4.scaleMatrix(sx: scale.x, sy: scale.y, sz: scale.z)

        return translationMatrix * rotationMatrix * scaleMatrix
    }

    var mdlMesh: MDLMesh

    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Can't create Metal device!")
        }

        let allocator = MTKMeshBufferAllocator(device: device)

        mdlMesh = MDLMesh(sphereWithExtent: [1, 1, 1], segments: [64, 64], inwardNormals: false, geometryType: .triangles, allocator: allocator)
    }
}
