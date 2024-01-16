import GameController

class KeyboardInputController {
    static let shared = KeyboardInputController()

    var isCommandPressed: Bool = false

    init() {
//        NotificationCenter.default.addObserver(forName: .GCKeyboardDidConnect, object: nil, queue: .main) { notification in
//            guard let keyboard = notification.object as? GCKeyboard else { return }
//            
//            keyboard.keyboardInput?.keyChangedHandler = { [weak self] _, _, keyCode, pressed in
//                guard let self = self else { return }
//
//                switch keyCode {
//                case .leftGUI, .rightGUI:
//                    isCommandPressed = pressed
//                default:
//                    break
//                }
//            }
//        }

        GCKeyboard.coalesced?.keyboardInput?.keyChangedHandler = { [weak self] _, _, keyCode, pressed in
            guard let self = self else { return }

            switch keyCode {
            case .leftGUI, .rightGUI:
                self.isCommandPressed = pressed
            default:
                break
            }
        }
    }
}
