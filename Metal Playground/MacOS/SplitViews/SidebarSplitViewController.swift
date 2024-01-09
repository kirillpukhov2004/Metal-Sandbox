import Cocoa
import SnapKit
import Combine

class SidebarSplitViewController: NSSplitViewController {
    var applicationController: ApplicationController

    private lazy var projectOutlineViewController: ProjectOutlineViewController = {
        guard let projectOutlineController = applicationController.projectOutlineController else {
            fatalError("Project controller not set")
        }

        let projectOutlineViewModel = ProjectOutlineViewModel(projectOutlineController: projectOutlineController)

        let projectOutlineViewController = ProjectOutlineViewController(viewModel: projectOutlineViewModel)

        return projectOutlineViewController
    }()

    private lazy var inspectorViewController: InspectorViewController = {
        guard let inspectorController = applicationController.inspectorController else {
            fatalError("Inspector controller no set")
        }

        let inspectorViewModel = InspectorViewModel(inspectorController: inspectorController)

        let inspectorViewController = InspectorViewController(viewModel: inspectorViewModel)

        return inspectorViewController
    }()

    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    init(applicationController: ApplicationController) {
        self.applicationController = applicationController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        splitView.isVertical = false

        let outlineViewControllerSplitViewItem = NSSplitViewItem(viewController: projectOutlineViewController)
        addSplitViewItem(outlineViewControllerSplitViewItem)

        let propertiesViewControllerSplitViewItem = NSSplitViewItem(viewController: inspectorViewController)
        addSplitViewItem(propertiesViewControllerSplitViewItem)
    }
}
