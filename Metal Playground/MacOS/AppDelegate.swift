import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        ApplicationController.shared.projectController = ProjectController()

        window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            defer: true
        )

        let mainMenu = NSMenu()
        NSApplication.shared.mainMenu = mainMenu

        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu

        appMenu.addItem(title: "About \(ProcessInfo.processInfo.processName)", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "", mask: [])

        appMenu.addSeparator()

        appMenu.addItem(title: "Quit \(ProcessInfo.processInfo.processName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q", mask: [.command])

        let minimumSize = CGSize(width: 800, height: 600)

        window?.contentMinSize = minimumSize
        window?.contentViewController = MainSplitViewController(applicationController: ApplicationController.shared)

        window?.setContentSize(minimumSize)

        window?.center()

        window?.makeKeyAndOrderFront(nil)
    }
}
