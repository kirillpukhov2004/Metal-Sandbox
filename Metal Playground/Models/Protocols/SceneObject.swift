import Foundation
import Combine

typealias AnySceneObject = any SceneObject

protocol SceneObject: AnyObject, Identifiable, Transformable where ID == UUID {
    var transformationPublisher: Published<Transformation>.Publisher { get }
}
