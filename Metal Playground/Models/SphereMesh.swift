import MetalKit

class SphereMesh: Mesh {
    var id: UUID = UUID()

    @Published var transformation: Transformation = Transformation()

    var transformationPublisher: Published<Transformation>.Publisher { $transformation }

    var mdlMesh: MDLMesh

    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Can't create Metal device!")
        }

        let allocator = MTKMeshBufferAllocator(device: device)

        mdlMesh = MDLMesh(sphereWithExtent: [1, 1, 1], segments: [64, 64], inwardNormals: false, geometryType: .triangles, allocator: allocator)
    }
}
