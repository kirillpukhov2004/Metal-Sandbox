import Combine

class ProjectController {
    private(set) var scene: Scene

    private(set) var viewportCamera: AnyCamera

    init(scene: Scene = Scene()) {
        self.scene = scene

        scene.meshes.append(SphereMesh())

        viewportCamera = ArcballCamera()
    }
}
