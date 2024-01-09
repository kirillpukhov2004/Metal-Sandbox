import AppKit
import Combine

class OutlineView: NSView {
    var dataSource: NSOutlineViewDataSource? {
        get {
            return outlineView.dataSource
        }

        set {
            outlineView.dataSource = newValue
        }
    }

    var delegate: NSOutlineViewDelegate? {
        get {
            return outlineView.delegate
        }

        set {
            outlineView.delegate = newValue
        }
    }

    var selectedRowIndex: Int {
        get {
            return outlineView.selectedRow
        }

        set {
            outlineView.selectRowIndexes(IndexSet([newValue]), byExtendingSelection: false)
        }
    }

    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()

        return scrollView
    }()

    private lazy var outlineView: NSOutlineView = {
        let outlineView = NSOutlineView()

        outlineView.headerView = nil
        outlineView.style = .sourceList

        let column = NSTableColumn()
        outlineView.addTableColumn(column)

        return outlineView
    }()

    override init(frame: NSRect) {
        super.init(frame: frame)

        scrollView.documentView = outlineView

        addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        outlineView.reloadData()
    }
}

extension OutlineView {
    var selectionDidChangedPublisher: AnyPublisher<NSOutlineView, Never> {
        return NotificationCenter.default.publisher(for: NSOutlineView.selectionDidChangeNotification, object: outlineView)
            .compactMap { $0.object as? NSOutlineView }
            .eraseToAnyPublisher()
    }
}
