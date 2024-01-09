import UIKit
import MetalKit
import SnapKit

class ViewController: UIViewController {
    var metalView: MTKView!

    private var label: UILabel!

    private var slider: UISlider!

    var renderer: Renderer!

    var nodes: [Node] = []

    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground

        setupViews()
        setupLayoutConstraints()

        renderer = Renderer(metalView: metalView)
    }

    func setupViews() {
        metalView = MTKView()
        view.addSubview(metalView)

        label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        view.addSubview(label)

        slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumValue = -10
        slider.maximumValue = 10
        slider.value = 0
        view.addSubview(slider)
    }
    
    func setupLayoutConstraints() {
        metalView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.bottom.equalTo(slider.snp.top).offset(-4)
            make.centerX.equalToSuperview()
        }

        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    @objc func sliderValueChanged() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2

        label.text = numberFormatter.string(from: NSNumber(value: slider.value))!
        renderer.camera.position = simd_float3(x: 0, y: 0, z: slider.value)
    }
}
