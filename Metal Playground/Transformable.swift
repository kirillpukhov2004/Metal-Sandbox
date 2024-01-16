import simd

protocol Transformable: AnyObject {
    var translation: SIMD3<Float> { get set }

    var rotation: SIMD3<Float> { get set }

    var scale: SIMD3<Float> { get set }

    var transformationMatrix: float4x4 { get }
}
