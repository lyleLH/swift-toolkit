import UIKit
import SwiftToolkit
import SwiftToolkitUI

class ButtonsExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Button Examples"
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        // 1. Confirmation Buttons (from UIButton+Confirmation)
        addLabel("Confirmation Style", to: stackView)
        // Note: Assuming makeConfirmationButton is available in public extension
        let primaryBtn = UIButton.makeConfirmationButton(title: "Primary", emoji: "👍", style: .primary)
        primaryBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        primaryBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(primaryBtn)
        
        let cancelBtn = UIButton.makeConfirmationButton(title: "Cancel", emoji: "✖️", style: .cancel)
        cancelBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(cancelBtn)
        
        let destructiveBtn = UIButton.makeConfirmationButton(title: "Destructive", emoji: "🗑️", style: .destructive)
        destructiveBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        destructiveBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(destructiveBtn)
        
        // 2. TweMoji Button
        addLabel("TweMoji Button", to: stackView)
        let tweMojiBtn = TweMojiButton(type: .system)
        tweMojiBtn.setTitle("TweMoji Button", for: .normal)
        stackView.addArrangedSubview(tweMojiBtn)
        
        // 3. Default Button
        addLabel("Default Button", to: stackView)
        let defaultBtn = DefaultButton(type: .system)
        defaultBtn.setTitle("Default Button", for: .normal)
        stackView.addArrangedSubview(defaultBtn)
    }
    
    private func addLabel(_ text: String, to stack: UIStackView) {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        stack.addArrangedSubview(label)
        stack.setCustomSpacing(10, after: label)
    }
}
