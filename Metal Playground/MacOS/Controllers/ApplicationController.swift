import Foundation
import Combine

final class ApplicationController {
    static let shared: ApplicationController = ApplicationController()

    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    var projectController: ProjectController? {
        didSet {
            if let projectController = projectController {
                viewportController = ViewportController(scene: projectController.scene, viewportCamera: projectController.viewportCamera)
                projectOutlineController = ProjectOutlineController(scene: projectController.scene, viewportCamera: projectController.viewportCamera)
                inspectorController = InspectorController()

                viewportController?.selectedSceneObjectsDidChangedPublisher
                    .compactMap { $0.selectedSceneObjects.first }
                    .removeDuplicates { $0 === $1 }
                    .filter { [weak self] sceneObject in
                        self?.inspectorController?.sceneObject !== sceneObject
                    }
                    .sink { [weak self] sceneObject in
                        self?.inspectorController?.sceneObject = sceneObject
                    }
                    .store(in: &subscriptions)

                projectOutlineController?.selectedSceneObjectsDidChangedPublisher
                    .compactMap { $0.selectedSceneObjects.first }
                    .removeDuplicates { $0 === $1 }
                    .filter { [weak self] sceneObject in
                        self?.inspectorController?.sceneObject !== sceneObject
                    }
                    .sink { [weak self] sceneObject in
                        self?.inspectorController?.sceneObject = sceneObject
                    }
                    .store(in: &subscriptions)
            }
        }
    }

    private(set) var viewportController: ViewportController?
    private(set) var projectOutlineController: ProjectOutlineController?
    private(set) var inspectorController: InspectorController?
}
