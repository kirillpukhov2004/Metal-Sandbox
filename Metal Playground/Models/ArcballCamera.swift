import Foundation
import simd

class ArcballCamera: Camera {
    var id: UUID = UUID()

    @Published var transformation: Transformation = Transformation()

    var transformationPublisher: Published<Transformation>.Publisher { $transformation }

    var projection: CameraProjection = .perspective

    var fov: Float = 65 * .pi / 180

    var aspectRatio: Float = 1

    var nearPlane: Float = 0.1

    var farPlane: Float = 100

    var minDistance: Float = 0.1

    var maxDistance: Float = 100

    var target: SIMD3<Float> = [0, 0, 0]

    var distance: Float = 2.5

    func update(size: Size) {
        aspectRatio = size.aspectRatio
    }

    func update(deltaTime: Float) {
        let vector = SIMD2<Float>(
            MouseInputController.shared.scroll.x,
            MouseInputController.shared.scroll.y
        )

        if vector.y != 0 {
            transformation.rotation.x += MouseInputController.shared.scroll.y * 0.008
            MouseInputController.shared.scroll.y = 0
        }
        
        if vector.x != 0 {
            transformation.rotation.y += MouseInputController.shared.scroll.x * 0.008
            MouseInputController.shared.scroll.x = 0
        }
    }
}
