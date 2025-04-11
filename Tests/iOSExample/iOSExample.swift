#if canImport(UIKit)
import UIKit
import SwiftToolkit

@available(iOS 16.0, *)
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // 配置HUD样式
        HUD.configure()
        
        // 创建按钮
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // 加载按钮
        let loadingButton = createButton(title: "显示加载")
        loadingButton.addTarget(self, action: #selector(showLoading), for: .touchUpInside)
        stackView.addArrangedSubview(loadingButton)
        
        // 成功按钮
        let successButton = createButton(title: "显示成功")
        successButton.addTarget(self, action: #selector(showSuccess), for: .touchUpInside)
        stackView.addArrangedSubview(successButton)
        
        // 错误按钮
        let errorButton = createButton(title: "显示错误")
        errorButton.addTarget(self, action: #selector(showError), for: .touchUpInside)
        stackView.addArrangedSubview(errorButton)
        
        // 进度按钮
        let progressButton = createButton(title: "显示进度")
        progressButton.addTarget(self, action: #selector(showProgress), for: .touchUpInside)
        stackView.addArrangedSubview(progressButton)
        
        // 自定义图标按钮
        let symbolButton = createButton(title: "显示自定义图标")
        symbolButton.addTarget(self, action: #selector(showSymbol), for: .touchUpInside)
        stackView.addArrangedSubview(symbolButton)
    }
    
    private func createButton(title: String) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        return button
    }
    
    @objc private func showLoading() {
        HUD.showLoading("正在加载...")
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            HUD.hide()
        }
    }
    
    @objc private func showSuccess() {
        HUD.showSuccess("操作成功")
    }
    
    @objc private func showError() {
        HUD.showError("操作失败")
    }
    
    @objc private func showProgress() {
        var progress: Float = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.1
            HUD.showProgress("正在下载...", progress: progress)
            if progress >= 1 {
                timer.invalidate()
                HUD.hide()
            }
        }
    }
    
    @objc private func showSymbol() {
        HUD.showSymbol("正在同步", symbolName: "arrow.triangle.2.circlepath")
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            HUD.hide()
        }
    }
}
#endif 