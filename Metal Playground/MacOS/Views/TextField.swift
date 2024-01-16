import AppKit
import Combine

class TextField: NSView {
    var label: String {
        willSet {
            labelTextField.stringValue = newValue
        }
    }

    var string: String {
        get {
            return textField.stringValue
        }

        set {
            textField.stringValue = newValue
        }
    }

    var textDidEndEditingPublisher: AnyPublisher<TextField, Never> {
        return NotificationCenter.default.publisher(for: NSTextField.textDidEndEditingNotification, object: textField)
            .map { _ in self }
            .eraseToAnyPublisher()
    }

    var textDidChangedPublisher: AnyPublisher<TextField, Never> {
        return NotificationCenter.default.publisher(for: NSTextField.textDidChangeNotification, object: textField)
            .map { _ in self }
            .eraseToAnyPublisher()
    }

    private lazy var containerStackView: NSStackView = {
        let containerStackView = NSStackView()

        containerStackView.orientation = .horizontal

        return containerStackView
    }()

    private lazy var labelTextField: NSTextField = {
        let labelTextField = NSTextField()

        labelTextField.isEditable = false
        labelTextField.drawsBackground = false
        labelTextField.isBezeled = false

        return labelTextField
    }()

    private lazy var textField: MyTextField = {
        let textField = MyTextField()
        
        textField.delegate = self
        textField.bezelStyle = .roundedBezel
        textField.focusRingType = .none

        return textField
    }()

    override init(frame: NSRect) {
        label = ""

        super.init(frame: frame)

        addSubview(containerStackView)
        containerStackView.addArrangedSubview(labelTextField)
        containerStackView.addArrangedSubview(textField)

        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextField: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
        case #selector(NSResponder.insertNewline):

            window?.makeFirstResponder(self)

            return true
        default:
            break
        }

        return false
    }
}
