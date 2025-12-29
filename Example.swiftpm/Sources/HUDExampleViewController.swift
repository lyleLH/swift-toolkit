#if canImport(UIKit)
import UIKit
import SwiftToolkit
import SwiftToolkitUI

@available(iOS 16.0, *)
class HUDExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "HUD Examples"
        
        HUD.configure()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let loadingButton = createButton(title: "Show Loading")
        loadingButton.addTarget(self, action: #selector(showLoading), for: .touchUpInside)
        stackView.addArrangedSubview(loadingButton)
        
        let successButton = createButton(title: "Show Success")
        successButton.addTarget(self, action: #selector(showSuccess), for: .touchUpInside)
        stackView.addArrangedSubview(successButton)
        
        let errorButton = createButton(title: "Show Error")
        errorButton.addTarget(self, action: #selector(showError), for: .touchUpInside)
        stackView.addArrangedSubview(errorButton)
        
        let progressButton = createButton(title: "Show Progress")
        progressButton.addTarget(self, action: #selector(showProgress), for: .touchUpInside)
        stackView.addArrangedSubview(progressButton)
        
        let symbolButton = createButton(title: "Show Custom Symbol")
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
        return UIButton(configuration: configuration)
    }
    
    @objc private func showLoading() {
        HUD.showLoading("Loading...")
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            HUD.hide()
        }
    }
    
    @objc private func showSuccess() {
        HUD.showSuccess("Success!")
    }
    
    @objc private func showError() {
        HUD.showError("Failed!")
    }
    
    @objc private func showProgress() {
        var progress: Float = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.1
            HUD.showProgress("Downloading...", progress: progress)
            if progress >= 1 {
                timer.invalidate()
                HUD.hide()
            }
        }
    }
    
    @objc private func showSymbol() {
        HUD.showSymbol("Syncing", symbolName: "arrow.triangle.2.circlepath")
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            HUD.hide()
        }
    }
}
#endif
