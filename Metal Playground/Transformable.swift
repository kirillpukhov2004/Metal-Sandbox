import simd

struct Transformation {
    var translation: SIMD3<Float> = .zero

    var rotation: SIMD3<Float> = .zero

    var scale: SIMD3<Float> = .one

    var matrix: float4x4 {
        let translationMatrix = float4x4.translationMatrix(tx: translation.x, ty: translation.y, tz: translation.z)

        let rotationMatrix = float4x4.rotationMatrix(rx: rotation.x, ry: rotation.y, rz: rotation.z)

        let scaleMatrix = float4x4.scaleMatrix(sx: scale.x, sy: scale.y, sz: scale.z)

        return translationMatrix * rotationMatrix * scaleMatrix
    }
}

protocol Transformable: AnyObject {
    var transformation: Transformation { get set }
}
