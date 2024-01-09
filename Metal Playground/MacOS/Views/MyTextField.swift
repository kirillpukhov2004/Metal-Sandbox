import AppKit

class MyTextField: NSTextField {
    override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() else {
            return false
        }

        DispatchQueue.main.async {
            self.currentEditor()?.selectAll(nil)
        }

        return true
    }

    override func mouseDown(with event: NSEvent) {

    }
}
