import MetalKit

typealias AnyMesh = any Mesh

protocol Mesh: SceneObject {
    var mdlMesh: MDLMesh { get set }
}
