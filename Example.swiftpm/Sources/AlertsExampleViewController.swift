import UIKit
import SwiftToolkit
import SwiftToolkitUI

class AlertsExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Alert Examples"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        addDemoButton(to: stackView, title: "Success Alert", action: #selector(showSuccessAlert))
        addDemoButton(to: stackView, title: "Delete Confirmation", action: #selector(showDeleteConfirmation))
        addDemoButton(to: stackView, title: "Discard Changes", action: #selector(showDiscardChanges))
        addDemoButton(to: stackView, title: "Custom Alert", action: #selector(showCustomAlert))
    }
    
    private func addDemoButton(to stack: UIStackView, title: String, action: Selector) {
        var config = UIButton.Configuration.filled()
        config.title = title
        let btn = UIButton(configuration: config)
        btn.addTarget(self, action: action, for: .touchUpInside)
        stack.addArrangedSubview(btn)
    }
    
    @objc private func showSuccessAlert() {
        let alert = AlertViewController.makeSuccessAlert(
            title: "Completed",
            message: "Your task has been completed successfully.",
            action: #selector(dummyAction),
            target: self
        )
        present(alert, animated: true)
    }
    
    @objc private func showDeleteConfirmation() {
        let alert = AlertViewController.makeDeleteConfirmation(
            deleteAction: #selector(dummyAction),
            cancelAction: nil,
            target: self
        )
        present(alert, animated: true)
    }
    
    @objc private func showDiscardChanges() {
        let alert = AlertViewController.makeDiscardChanges(
            discardAction: #selector(dummyAction),
            cancelAction: nil,
            target: self
        )
        present(alert, animated: true)
    }
    
    @objc private func showCustomAlert() {
        let alert = AlertViewController.makeCustomAlert(
            title: "Choose Option",
            message: "What would you like to do?",
            primaryButton: (title: "Save", emoji: "💾", action: #selector(dummyAction)),
            secondaryButton: (title: "Share", emoji: "📤", action: #selector(dummyAction)),
            target: self
        )
        present(alert, animated: true)
    }
    
    @objc private func dummyAction() {
        print("Action triggered")
    }
}
