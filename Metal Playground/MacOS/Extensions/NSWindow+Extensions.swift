import AppKit

extension NSWindow {
    convenience init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, defer flag: Bool) {
        self.init(
            contentRect: contentRect,
            styleMask: style,
            backing: .buffered,
            defer: flag
        )
    }
}
