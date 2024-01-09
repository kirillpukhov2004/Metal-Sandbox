import AppKit
import Combine

class MainSplitViewController: NSSplitViewController {
    var applicationController: ApplicationController

    private lazy var viewPortViewController: ViewPortViewController = {
        guard let viewportController = applicationController.viewportController else {
            fatalError("Viewport controller not set")
        }

        let viewPortViewModel = ViewPortViewModel(viewportController: viewportController)

        let viewPortViewController = ViewPortViewController(viewModel: viewPortViewModel)

        return viewPortViewController
    }()

    private lazy var sidebarSplitViewController: SidebarSplitViewController = {
        let sidebarSplitViewController = SidebarSplitViewController(applicationController: applicationController)

        return sidebarSplitViewController
    }()

    init(applicationController: ApplicationController) {
        self.applicationController = applicationController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewPortViewControllerSplitViewItem = NSSplitViewItem(viewController: viewPortViewController)
        viewPortViewControllerSplitViewItem.holdingPriority = NSLayoutConstraint.Priority(199)
        addSplitViewItem(viewPortViewControllerSplitViewItem)

        let sidebarSplitViewControllerSplitViewItem = NSSplitViewItem(sidebarWithViewController: sidebarSplitViewController)
        sidebarSplitViewControllerSplitViewItem.holdingPriority = NSLayoutConstraint.Priority(200)
        sidebarSplitViewControllerSplitViewItem.minimumThickness = 150
        sidebarSplitViewControllerSplitViewItem.maximumThickness = 500
        addSplitViewItem(sidebarSplitViewControllerSplitViewItem)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        let toolbar = NSToolbar(identifier: "MainToolbar")
        view.window?.toolbar = toolbar

        toolbar.delegate = self
        toolbar.allowsUserCustomization = true
        toolbar.displayMode = .iconOnly

        toolbar.insertItem(withItemIdentifier: .customToggleSidebar, at: 0)

        splitView.setPosition(splitView.frame.width - 300, ofDividerAt: 0)
    }

    override func mouseDown(with event: NSEvent) {
        view.window?.makeFirstResponder(self)
    }
}

extension NSToolbarItem.Identifier {
    static let customToggleSidebar = NSToolbarItem.Identifier("customToggleSidebar")
}

extension MainSplitViewController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.customToggleSidebar]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.customToggleSidebar]
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if itemIdentifier == .customToggleSidebar {
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)

            item.label = "Sidebar"
            item.image = NSImage(systemSymbolName: "sidebar.right", accessibilityDescription: nil)
            item.target = self
            item.action = #selector(toggleSidebar(_:))

            return item
        }

        return nil
    }
}
