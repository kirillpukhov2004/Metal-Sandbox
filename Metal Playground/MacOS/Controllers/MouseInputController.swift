import GameController

class MouseInputController {
    static let shared = MouseInputController()

    var scroll: Point = .zero

    init() {
        NotificationCenter.default.addObserver(forName: .GCMouseDidConnect, object: nil, queue: .main) { notification in
            guard let mouse = notification.object as? GCMouse else { return }

            mouse.mouseInput?.scroll.valueChangedHandler = { [weak self] _, xValue, yValue in
                guard let self = self else { return }

                scroll.x += xValue

                scroll.y += yValue
            }
        }
    }
}
