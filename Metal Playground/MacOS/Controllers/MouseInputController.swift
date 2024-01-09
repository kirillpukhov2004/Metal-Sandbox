import GameController

struct Point {
    var x: Float

    var y: Float

    static var zero = Point(x: 0, y: 0)
}

class MouseInputController {
    static var shared = MouseInputController()

    var scroll: Point

    init() {
        scroll = .zero

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
