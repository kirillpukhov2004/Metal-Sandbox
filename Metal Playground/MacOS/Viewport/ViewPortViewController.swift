import AppKit
import MetalKit
import SnapKit
import GameController

class ViewPortViewController: NSViewController {
    private var viewModel: ViewPortViewModel

    private lazy var metalView: MTKView = {
        let metalView = MTKView()

        return metalView
    }()

    init(viewModel: ViewPortViewModel) {
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

        viewModel.renderer.metalView = metalView
    }

    override func viewDidAppear() {
        viewModel.viewportController.viewportCamera.update(size: Size(metalView.drawableSize))
    }

    private func setupViews() {
        view.addSubview(metalView)
    }

    private func setupLayoutConstraints() {
        metalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
