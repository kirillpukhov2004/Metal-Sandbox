import Foundation
import Combine

typealias AnySceneObject = any SceneObject

protocol SceneObject: AnyObject, Identifiable, Transformable where ID == UUID {
    var translationPublisher: Published<SIMD3<Float>>.Publisher { get }

    var rotationPublisher: Published<SIMD3<Float>>.Publisher { get }

    var scalePublisher: Published<SIMD3<Float>>.Publisher { get }
}
