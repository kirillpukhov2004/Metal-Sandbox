import Combine

final class ViewportController {
    private(set) var scene: Scene

    private(set) var viewportCamera: AnyCamera

    var selectedSceneObjects: [AnySceneObject] = [] {
        didSet {
            selectedSceneObjectsDidChangedSubject.send(self)
        }
    }

    private var selectedSceneObjectsDidChangedSubject: PassthroughSubject<ViewportController, Never> = PassthroughSubject<ViewportController, Never>()

    var selectedSceneObjectsDidChangedPublisher: AnyPublisher<ViewportController, Never> {
        return selectedSceneObjectsDidChangedSubject.eraseToAnyPublisher()
    }

    init(scene: Scene, viewportCamera: AnyCamera) {
        self.scene = scene
        self.viewportCamera = viewportCamera
    }
}
