import simd

struct Uniforms {
    var modelMatrix: simd_float4x4
    var viewMatrix: simd_float4x4
    var projectionMatrix: simd_float4x4
}
