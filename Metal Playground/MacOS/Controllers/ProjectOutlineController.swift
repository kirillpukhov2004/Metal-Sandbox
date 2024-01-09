import Combine

class ProjectOutlineController {
    private(set) var viewportCamera: AnyCamera

    private(set) var scene: Scene

    var rootProjectOutlineItem: ProjectOutlineItem = ProjectOutlineItem(type: .group) {
        didSet {
            rootProjectOutlineItemDidChangedSubject.send(self)
        }
    }

    var selectedSceneObjects: [AnySceneObject] = [] {
        didSet {
            selectedSceneObjectsDidChangedSubject.send(self)
        }
    }

    private var rootProjectOutlineItemDidChangedSubject: PassthroughSubject<ProjectOutlineController, Never> = PassthroughSubject<ProjectOutlineController, Never>()
    var rootProjectOutlineItemDidChangedPublisher: AnyPublisher<ProjectOutlineController, Never> {
        return rootProjectOutlineItemDidChangedSubject.eraseToAnyPublisher()
    }

    private var selectedSceneObjectsDidChangedSubject: PassthroughSubject<ProjectOutlineController, Never> = PassthroughSubject<ProjectOutlineController, Never>()
    var selectedSceneObjectsDidChangedPublisher: AnyPublisher<ProjectOutlineController, Never> {
        return selectedSceneObjectsDidChangedSubject.eraseToAnyPublisher()
    }

    init(scene: Scene, viewportCamera: AnyCamera) {
        self.scene = scene
        
        self.viewportCamera = viewportCamera

        updateProjectOutlineItems()
    }

    private func updateProjectOutlineItems() {
        var rootProjectOutlineItem = ProjectOutlineItem(type: .group)

        let viewportCameraProjectOutlineItem = ProjectOutlineItem(type: .sceneObject(viewportCamera))

        rootProjectOutlineItem.subitems.append(viewportCameraProjectOutlineItem)

        scene.cameras.forEach { camera in
            let projectOutlineItem = ProjectOutlineItem(type: .sceneObject(camera))

            rootProjectOutlineItem.subitems.append(projectOutlineItem)
        }

        scene.lights.forEach { light in
            let projectOutlineItem = ProjectOutlineItem(type: .sceneObject(light))

            rootProjectOutlineItem.subitems.append(projectOutlineItem)
        }

        scene.meshes.forEach { mesh in
            let projectOutlineItem = ProjectOutlineItem(type: .sceneObject(mesh))

            rootProjectOutlineItem.subitems.append(projectOutlineItem)
        }

        self.rootProjectOutlineItem = rootProjectOutlineItem
    }
}
