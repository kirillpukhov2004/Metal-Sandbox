import Combine

class InspectorController {
    var sceneObject: AnySceneObject? {
        didSet {
            sceneObjectsDidChangedSubject.send()
        }
    }

    private var sceneObjectsDidChangedSubject: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()

    var sceneObjectsDidChangedPublisher: AnyPublisher<Void, Never> {
        return sceneObjectsDidChangedSubject.eraseToAnyPublisher()
    }
}
