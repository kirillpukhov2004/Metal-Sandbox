import Cocoa
import Combine
import SnapKit

class ProjectOutlineViewController: NSViewController {
    var viewModel: ProjectOutlineViewModel

    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    private lazy var outlineView: OutlineView = {
        let outlineView = OutlineView()

        outlineView.dataSource = self
        outlineView.delegate = self

        return outlineView
    }()

    init(viewModel: ProjectOutlineViewModel) {
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
        super.viewDidLoad()

        outlineView.selectionDidChangedPublisher
            .map { outlineView in
                let selectedRow = outlineView.selectedRow

                let projectOutlineViewItem = outlineView.item(atRow: selectedRow) as? ProjectOutlineItem

                switch projectOutlineViewItem?.type {
                case .sceneObject(let sceneObject):
                    return [sceneObject]
                default:
                    return []
                }
            }
            .sink { [weak self] selectedSceneObjects in
                self?.viewModel.projectOutlineController.selectedSceneObjects = selectedSceneObjects
            }
            .store(in: &subscriptions)
    }

    private func setupViews() {
        view.addSubview(outlineView)
    }

    private func setupLayoutConstraints() {
        outlineView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ProjectOutlineViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item = item as? ProjectOutlineItem else {
            return viewModel.projectOutlineController.rootProjectOutlineItem.subitems.count
        }

        return item.subitems.count
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item = item as? ProjectOutlineItem else {
            return viewModel.projectOutlineController.rootProjectOutlineItem.subitems[index]
        }

        return item.subitems[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let item = item as? ProjectOutlineItem else {
            return false
        }

        return item.type == .group
    }
}

extension ProjectOutlineViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = item as? ProjectOutlineItem else {
            return nil
        }

        switch item.type {
        case .group:
            let cell = SceneOutlineViewCell()

            cell.titleTextField.stringValue = "Group"

            return cell
        case .sceneObject(let sceneObject):
            switch sceneObject {
            case is any Camera:
                let cell = SceneOutlineViewCell()

                cell.titleTextField.stringValue = "Camera"

                return cell
            case is any Light:
                let cell = SceneOutlineViewCell()

                cell.titleTextField.stringValue = "Light"

                return cell
            case is any Mesh:
                let cell = SceneOutlineViewCell()

                cell.titleTextField.stringValue = "Object"

                return cell
            default:
                return nil
            }
        }
    }
}
