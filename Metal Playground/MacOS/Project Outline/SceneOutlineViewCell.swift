import Cocoa

class SceneOutlineViewCell: NSView {
    lazy var titleTextField: NSTextField = {
        let titleTextField = NSTextField()

        titleTextField.isEditable = false
        titleTextField.drawsBackground = false
        titleTextField.isBezeled = false

        return titleTextField
    }()

    override init(frame: NSRect) {
        super.init(frame: frame)

        addSubview(titleTextField)

        titleTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
