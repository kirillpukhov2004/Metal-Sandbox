import AppKit

extension NSMenuItem {
    convenience init(title: String, action: Selector?, keyEquivalent: String, mask: NSEvent.ModifierFlags) {
        self.init(title: title, action: action, keyEquivalent: keyEquivalent)
        self.keyEquivalentModifierMask = mask
    }
}
