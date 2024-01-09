import AppKit
import Combine

class XYZPropertiesTableViewItem: NSView {
    var label: String {
        get {
            return labelTextField.stringValue
        }

        set {
            labelTextField.isHidden = newValue.isEmpty
            labelTextField.stringValue = newValue
        }
    }

    private(set) var vector: SIMD3<Float> = .zero

    private var vectorDidChangedSubject: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()

    var vectorDidChangedPublisher: AnyPublisher<Void, Never> {
        return vectorDidChangedSubject.eraseToAnyPublisher()
    }

    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2

        return numberFormatter
    }()

    private lazy var containerStackView: NSStackView = {
        let containerStackView = NSStackView()

        containerStackView.orientation = .vertical
        containerStackView.distribution = .fill
        containerStackView.alignment = .leading

        return containerStackView
    }()

    private lazy var labelTextField: NSTextField = {
        let labelTextField = NSTextField()

        labelTextField.isEditable = false
        labelTextField.isBezeled = false
        labelTextField.drawsBackground = false
        labelTextField.font = .preferredFont(forTextStyle: .headline)
        labelTextField.textColor = .secondaryLabelColor
        labelTextField.alignment = .natural

        return labelTextField
    }()

    private lazy var xTextField: TextField = {
        let xTextField = TextField()

        xTextField.label = "X"

        return xTextField
    }()

    private lazy var yTextField: TextField = {
        let yTextField = TextField()

        yTextField.label = "Y"

        return yTextField
    }()

    private lazy var zTextField: TextField = {
        let zTextField = TextField()

        zTextField.label = "Z"

        return zTextField
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        setupViews()
        setupLayoutConstraints()
        setupSubscriptions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        labelTextField.isHidden = true

        addSubview(containerStackView)
        containerStackView.addArrangedSubview(labelTextField)
        containerStackView.addArrangedSubview(xTextField)
        containerStackView.addArrangedSubview(yTextField)
        containerStackView.addArrangedSubview(zTextField)
    }

    private func setupLayoutConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupSubscriptions() {
        xTextField.textDidEndEditingPublisher
            .compactMap { [weak self] () -> Float? in
                guard let self = self else { return nil }

                return numberFormatter.number(from: xTextField.string)?.floatValue
            }
            .sink { [weak self] in
                guard let self = self else { return }

                xTextField.string = numberFormatter.string(from: NSNumber(value: $0))!
                vector.x = $0
                vectorDidChangedSubject.send()
            }
            .store(in: &subscriptions)

        yTextField.textDidEndEditingPublisher
            .compactMap { [weak self] () -> Float? in
                guard let self = self else { return nil }

                return numberFormatter.number(from: yTextField.string)?.floatValue
            }
            .sink { [weak self] in
                guard let self = self else { return }

                yTextField.string = numberFormatter.string(from: NSNumber(value: $0))!
                vector.y = $0
                vectorDidChangedSubject.send()
            }
            .store(in: &subscriptions)

        zTextField.textDidEndEditingPublisher
            .compactMap { [weak self] () -> Float? in
                guard let self = self else { return nil }

                return numberFormatter.number(from: zTextField.string)?.floatValue
            }
            .sink { [weak self] in
                guard let self = self else { return }

                zTextField.string = numberFormatter.string(from: NSNumber(value: $0))!
                vector.z = $0
                vectorDidChangedSubject.send()
            }
            .store(in: &subscriptions)
    }

    func updateVector(vector: SIMD3<Float>) {
        self.vector = vector

        xTextField.string = numberFormatter.string(from: NSNumber(value: vector.x))!
        yTextField.string = numberFormatter.string(from: NSNumber(value: vector.y))!
        zTextField.string = numberFormatter.string(from: NSNumber(value: vector.z))!
    }
}
