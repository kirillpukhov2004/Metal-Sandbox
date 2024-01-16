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
        let yScale = 1 / tan(fov / 2)
        let xScale = yScale / aspectRatio
        let zScale = far / (far - near)

        let rows = [
            SIMD4<Float>(xScale, 0, 0, 0),
            SIMD4<Float>(0, yScale, 0, 0),
            SIMD4<Float>(0, 0, zScale, zScale * -near),
            SIMD4<Float>(0, 0, 1, 0)
        ]

//        let t = tan(fov / 2)
//
//        let x = Float(1 / (aspectRatio * t))
//        let y = Float(1 / t)
//        let z = Float(-((far + near) / (far - near)))
//        let w = Float(-((2 * far * near) / (far - near)))
//
//        let rows = [
//            SIMD4<Float>(x, 0, 0, 0),
//            SIMD4<Float>(0, y, 0, 0),
//            SIMD4<Float>(0, 0, z, w),
//            SIMD4<Float>(0, 0, -1, 0)
//        ]

        return float4x4(rows: rows)
    }

    static func orthogonalProjectionMatrix(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> float4x4 {
        let rows = [
            SIMD4<Float>(2 / (right - left), 0, 0, -(right + left) / (right - left)),
            SIMD4<Float>(0, 2 / (top - bottom), 0, -(top + bottom) / (top - bottom)),
            SIMD4<Float>(0, 0,  -1 / (far - near), -near / (far - near)),
            SIMD4<Float>(0, 0, 0, 1)
        ]

        return float4x4(rows: rows)
    }

    static func lookAtMatrix(eye: SIMD3<Float>, center: SIMD3<Float>, up: SIMD3<Float>) -> float4x4 {
        let zAxis = normalize(center - eye)
        let xAxis = normalize(cross(up, zAxis))
        let yAxis = cross(zAxis, xAxis)

        let rows = [ 
            SIMD4<Float>(xAxis.x, yAxis.x, zAxis.x, 0),
            SIMD4<Float>(xAxis.y, yAxis.y, zAxis.y, 0),
            SIMD4<Float>(xAxis.z, yAxis.z, zAxis.z, 0),
            SIMD4<Float>(-dot(xAxis, eye), -dot(yAxis, eye), -dot(zAxis, eye), 1)
        ]

        return float4x4(rows: rows)
    }

    init(eye: float3, center: float3, up: float3) {
      let z = normalize(center - eye)
      let x = normalize(cross(up, z))
      let y = cross(z, x)

      let X = float4(x.x, y.x, z.x, 0)
      let Y = float4(x.y, y.y, z.y, 0)
      let Z = float4(x.z, y.z, z.z, 0)
      let W = float4(-dot(x, eye), -dot(y, eye), -dot(z, eye), 1)

      self.init()
      columns = (X, Y, Z, W)
    }
}

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        return SIMD3<Scalar>(x: x, y: y, z: z)
    }
}
