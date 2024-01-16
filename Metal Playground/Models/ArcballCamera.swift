import Foundation
import simd

class ArcballCamera: Camera {
    var id: UUID = UUID()

    @Published var translation: SIMD3<Float> = .zero
    var translationPublisher: Published<SIMD3<Float>>.Publisher { $translation }

    @Published var rotation: SIMD3<Float> = .zero
    var rotationPublisher: Published<SIMD3<Float>>.Publisher { $rotation }

    @Published var scale: SIMD3<Float> = .one
    var scalePublisher: Published<SIMD3<Float>>.Publisher { $scale }

    var transformationMatrix: float4x4 {
        return float4x4(eye: translation, center: target, up: SIMD3<Float>(0, 1, 0))
    }

    var projection: CameraProjection = .perspective

    var fov: Float = 65 * .pi / 180

    var aspectRatio: Float = 1

    var nearPlane: Float = 0.1

    var farPlane: Float = 100

    var minDistance: Float = 0.1

    var maxDistance: Float = 100

    var target: SIMD3<Float> = [0, 0, 0]

    var distance: Float = 0 {
        didSet {
            print("distance: \(distance)")
        }
    }

    func update(size: Size) {
        aspectRatio = size.aspectRatio
    }

    func update(deltaTime: Float) {
        let scroll = MouseInputController.shared.scroll

        guard scroll.x + scroll.y != 0 else { return }

        if KeyboardInputController.shared.isCommandPressed {
            distance += (scroll.x + scroll.y) * 0.008
            distance = min(maxDistance, max(minDistance, distance))
        } else {
            rotation.x += MouseInputController.shared.scroll.y * 0.008
            rotation.x = clipAngleToPi(rotation.x)

            rotation.y += MouseInputController.shared.scroll.x * 0.008
            rotation.y = clipAngleToPi(rotation.y)
        }

        MouseInputController.shared.scroll = .zero

        let rotationMatrix = float4x4.rotationMatrix(rx: -rotation.x, ry: rotation.y, rz: rotation.z)
        let distanceVector = SIMD4<Float>(0, 0, -distance, 0)
        let rotatedVector = rotationMatrix * distanceVector
        translation = target + rotatedVector.xyz
    }

    func clipAngleToPi(_ angle: Float) -> Float {
        var clippedAngle = angle.truncatingRemainder(dividingBy: 2.0 * .pi)

        if clippedAngle > .pi {
            clippedAngle -= 2.0 * .pi
        } else if clippedAngle <= -.pi {
            clippedAngle += 2.0 * .pi
        }

        return clippedAngle
    }
}
