import Foundation
import Combine

class ProjectOutlineViewModel {
    var projectOutlineController: ProjectOutlineController

    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    init(projectOutlineController: ProjectOutlineController) {
        self.projectOutlineController = projectOutlineController
    }
}
