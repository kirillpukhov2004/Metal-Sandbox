import Foundation

class ViewPortViewModel {
    var viewportController: ViewportController

    var renderer: Renderer

    init(viewportController: ViewportController) {
        self.viewportController = viewportController

        renderer = Renderer(viewportController: viewportController)
    }
}
