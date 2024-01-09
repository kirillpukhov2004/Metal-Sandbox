import Foundation
import simd

extension float4x4 {
    static func translationMatrix(tx: Float, ty: Float, tz: Float) -> float4x4 {
        var matrix = matrix_identity_float4x4

        matrix[3][0] = tx
        matrix[3][1] = ty
        matrix[3][2] = tz

        return matrix
    }

    static func scaleMatrix(sx: Float, sy: Float, sz: Float) -> float4x4 {
        var matrix = matrix_identity_float4x4

        matrix[0][0] = sx
        matrix[1][1] = sy
        matrix[2][2] = sz

        return matrix
    }

    private static func rotationMatrix(rx angle: Float) -> float4x4 {
        return float4x4(
            [1, 0         , 0          , 0],
            [0, cos(angle), -sin(angle), 0],
            [0, sin(angle), cos(angle) , 0],
            [0, 0         , 0          , 1]
        )
    }

    private static func rotationMatrix(ry angle: Float) -> float4x4{
        return float4x4(
            [cos(angle) , 0, sin(angle), 0],
            [0          , 1, 0         , 0],
            [-sin(angle), 0, cos(angle), 0],
            [0          , 0, 0         , 1]
        )
    }

    private static func rotationMatrix(rz angle: Float) -> float4x4 {
        return float4x4(
            [ cos(angle), -sin(angle), 0, 0],
            [ sin(angle), cos(angle) , 0, 0],
            [ 0         , 0          , 1, 0],
            [ 0         , 0          , 0, 1]
        )
    }

    static func rotationMatrix(rx: Float, ry: Float, rz: Float) -> float4x4 {
        let rotationX = rotationMatrix(rx: rx)
        let rotationY = rotationMatrix(ry: ry)
        let rotationZ = rotationMatrix(rz: rz)

        return rotationX * rotationY * rotationZ
    }

    static func perspectiveProjectionMatrix(fov: Float, aspectRatio: Float, near: Float, far: Float) -> float4x4 {
        let t = Float(tan(fov / 2))

        let x = Float(1 / (aspectRatio * t))
        let y = Float(1 / t)
        let z = Float(-((far + near) / (far - near)))
        let w = Float(-((2 * far * near) / (far - near)))

        let rows = [
            simd_float4(x, 0, 0, 0),
            simd_float4(0, y, 0, 0),
            simd_float4(0, 0, z, w),
            simd_float4(0, 0, -1, 0)
        ]

        return float4x4(rows: rows)
    }

    static func orthogonalProjectionMatrix(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> float4x4 {
        let rows = [
            simd_float4(2 / (right - left), 0, 0, -(right + left) / (right - left)),
            simd_float4(0, 2 / (top - bottom), 0, -(top + bottom) / (top - bottom)),
            simd_float4(0, 0,  -1 / (far - near), -near / (far - near)),
            simd_float4(0, 0, 0, 1)
        ]

        return float4x4(rows: rows)
    }
}
