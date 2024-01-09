import AppKit

extension NSMenu {
    func addItem(title: String, action: Selector?, keyEquivalent: String, mask: NSEvent.ModifierFlags) {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        item.keyEquivalentModifierMask = mask
        addItem(item)
    }

    func addSeparator() {
        addItem(NSMenuItem.separator())
    }
}
