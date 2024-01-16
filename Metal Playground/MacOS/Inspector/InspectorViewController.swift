import AppKit
import Combine
import simd

enum TransformableProperty: CaseIterable {
    case translation
    case rotation
    case scale
}

class InspectorViewController: NSViewController {
    var viewModel: InspectorViewModel

    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()

        return scrollView
    }()

    private lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.headerView = nil
        tableView.usesAutomaticRowHeights = true
        tableView.intercellSpacing = NSSize(width: 0, height: 8)

        let column = NSTableColumn()
        tableView.addTableColumn(column)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    init(viewModel: InspectorViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()

        setupViews()
        setupLayoutConstraints()
    }

    override func viewDidLoad() {
        viewModel.inspectorController.sceneObjectsDidChangedPublisher
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }

    private func setupViews() {
        scrollView.documentView = tableView
        view.addSubview(scrollView)
    }

    private func setupLayoutConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension InspectorViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let sceneObject = viewModel.inspectorController.sceneObject else {
            return 0
        }

        switch sceneObject {
        case is AnyCamera:
            return TransformableProperty.allCases.count
        case is AnyMesh:
            return TransformableProperty.allCases.count
        default:
            return 0
        }
    }
}

extension InspectorViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let sceneObject = viewModel.inspectorController.sceneObject else {
            return nil
        }

        let item = XYZPropertiesTableViewItem()

        switch TransformableProperty.allCases[row] {
        case .translation:
            item.label = "Translation"

            sceneObject.translationPublisher
                .removeDuplicates()
                .assign(to: &item.$vector)

            item.$vector
                .removeDuplicates()
                .assign(to: \.translation, on: sceneObject)
                .store(in: &subscriptions)

        case .rotation:
            item.label = "Rotation"

            sceneObject.rotationPublisher
                .removeDuplicates()
                .map { radVector in
                    var gradVector = SIMD3<Float>()

                    gradVector.x = radVector.x * 180 / .pi
                    gradVector.y = radVector.y * 180 / .pi
                    gradVector.z = radVector.z * 180 / .pi

                    return gradVector
                }
                .assign(to: &item.$vector)

            item.$vector
                .removeDuplicates()
                .map { gradVector in
                    var radVector = SIMD3<Float>()

                    radVector.x = gradVector.x * .pi / 180
                    radVector.y = gradVector.y * .pi / 180
                    radVector.z = gradVector.z * .pi / 180

                    return radVector
                }
                .assign(to: \.rotation, on: sceneObject)
                .store(in: &subscriptions)
        case .scale:
            item.label = "Scale"

            sceneObject.scalePublisher
                .removeDuplicates()
                .assign(to: &item.$vector)

            item.$vector
                .removeDuplicates()
                .assign(to: \.scale, on: sceneObject)
                .store(in: &subscriptions)
        }

        return item
    }
}
