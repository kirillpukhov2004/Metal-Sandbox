import Foundation
import simd

typealias AnyCamera = any Camera

enum CameraProjection {
    case perspective
    case orthogonal
}

protocol Camera: SceneObject, Transformable {
    var projection: CameraProjection { get set }

    var fov: Float { get set }

    var aspectRatio: Float { get set }

    var nearPlane: Float { get set }

    var farPlane: Float { get set }

    var projectionMatrix: float4x4 { get }

    func update(size: Size)

    func update(deltaTime: Float)
}

extension Camera {
    var projectionMatrix: float4x4 {
        switch projection {
        case .perspective:
            return float4x4.perspectiveProjectionMatrix(
                fov: fov,
                aspectRatio: aspectRatio,
                near: nearPlane,
                far: farPlane
            )
        case .orthogonal:
            return float4x4.orthogonalProjectionMatrix(
                left: -1,
                right: 1,
                bottom: -1,
                top: 1,
                near: nearPlane,
                far: farPlane
            )
        }
    }
}
