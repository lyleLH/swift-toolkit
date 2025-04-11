import UIKit

 
final class AlertViewController: UIViewController {
    
    // MARK: - Types
    enum ButtonType {
        case primary
        case secondary
        case tertiary
    }
    
    struct ButtonConfig {
        let title: String
        let emoji: String?
        let style: UIButton.ConfirmationStyle
        let action: Selector?
        
        static func makeDefault(
            primary: (title: String, emoji: String?, action: Selector?),
            secondary: (title: String, emoji: String?, action: Selector?)? = nil,
            tertiary: (title: String, emoji: String?, action: Selector?)? = nil
        ) -> [ButtonConfig] {
            var configs: [ButtonConfig] = [
                ButtonConfig(title: primary.title, emoji: primary.emoji, style: .primary, action: primary.action)
            ]
            
            if let secondary = secondary {
                configs.append(ButtonConfig(title: secondary.title, emoji: secondary.emoji, style: .cancel, action: secondary.action))
            }
            
            if let tertiary = tertiary {
                configs.append(ButtonConfig(title: tertiary.title, emoji: tertiary.emoji, style: .cancel, action: tertiary.action))
            }
            
            return configs
        }
    }
    
    enum ButtonLayout {
        case single    // 一个按钮
        case double    // 两个按钮
        case triple    // 三个按钮
        
        var stackAxis: NSLayoutConstraint.Axis {
            switch self {
            case .single, .double:
                return .horizontal
            case .triple:
                return .vertical
            }
        }
        
        var buttonSpacing: CGFloat {
            switch self {
            case .single:
                return 0
            case .double:
                return 8
            case .triple:
                return 8
            }
        }
    }
    
    enum Style {
        case alert
        case actionSheet
    }
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 20
        static let titleHeight: CGFloat = 22
        static let buttonHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 10
        
        static let topSpacing: CGFloat = 24
        static let bottomSpacing: CGFloat = 20
        static let verticalSpacing: CGFloat = 16
        
        static let messageMinHeight: CGFloat = 60
        static let messageMaxHeight: CGFloat = 200
        static let messagePadding: CGFloat = 16
        
        static let buttonStackHeight: CGFloat = 160 // 足够容纳三个按钮的高度
    }
    
    // MARK: - Properties
    private let titleText: String
    private let messageText: String
    private let buttons: [ButtonConfig]
    private let buttonLayout: ButtonLayout
    private let style: Style
    private weak var target: NSObject?
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = CustomFont.poppinsSemiBold.font(size: 17)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = messageText
        label.font =  CustomFont.poppinsRegular.font(size: 15)
        label.textColor = .mainGreen
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    init(title: String, message: String, buttons: [ButtonConfig], style: Style = .alert, target: NSObject? = nil) {
        self.titleText = title
        self.messageText = message
        self.buttons = buttons
        self.buttonLayout = {
            switch buttons.count {
            case 1: return .single
            case 2: return .double
            case 3: return .triple
            default: return .single
            }
        }()
        self.style = style
        self.target = target
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = sheetPresentationController {
                sheet.prefersGrabberVisible = true
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 20
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.topSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding),
            
            buttonStack.topAnchor.constraint(greaterThanOrEqualTo: messageLabel.bottomAnchor, constant: Constants.verticalSpacing),
            buttonStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
            buttonStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding),
            buttonStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.bottomSpacing)
        ])
        
        setupButtons()
    }
    
    private func setupButtons() {
        // 移除现有按钮
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 创建并添加按钮
        buttons.enumerated().forEach { index, config in
            let button = UIButton.makeConfirmationButton(
                title: config.title,
                emoji: config.emoji ?? "",
                style: config.style
            )
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            // 设置按钮的约束
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
            
            // 直接将按钮添加到 stack view
            buttonStack.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        // 如果有指定的 action，则执行
        if let action = buttons[sender.tag].action {
            // 使用 target-action 模式执行 selector
            target?.perform(action)
        }
        
        // 如果没有指定 action，直接关闭 alert
        if buttons[sender.tag].action == nil {
            dismiss(animated: true)
        }
    }
}

// MARK: - Factory Methods
extension AlertViewController {
    static func makeSuccessAlert(
        title: String,
        message: String,
        action: Selector? = nil,
        target: NSObject? = nil
    ) -> AlertViewController {
        let buttons = ButtonConfig.makeDefault(
            primary: ("ok".localized, "✅", action),
            secondary: nil
        )
        return AlertViewController(title: title, message: message, buttons: buttons, style: .alert, target: target)
    }
    
    static func makeDeleteConfirmation(
        deleteAction: Selector? = nil,
        cancelAction: Selector? = nil,
        target: NSObject? = nil
    ) -> AlertViewController {
        let buttons = ButtonConfig.makeDefault(
            primary: ("delete".localized, "🗑️", deleteAction),
            secondary: ("cancel".localized, "❌", cancelAction)
        )
        return AlertViewController(
            title: "alert.delete_title".localized,
            message: "alert.delete_warning".localized,
            buttons: buttons,
            style: .alert,
            target: target
        )
    }
    
    static func makeDiscardChanges(
        discardAction: Selector? = nil,
        cancelAction: Selector? = nil,
        target: NSObject? = nil
    ) -> AlertViewController {
        let buttons = ButtonConfig.makeDefault(
            primary: ("discard".localized, "🗑️", discardAction),
            secondary: ("cancel".localized, "❌", cancelAction)
        )
        return AlertViewController(
            title: "alert.discard_changes_title".localized,
            message: "alert.discard_changes_message".localized,
            buttons: buttons,
            style: .alert,
            target: target
        )
    }
    
    static func makeCustomAlert(
        title: String,
        message: String,
        primaryButton: (title: String, emoji: String?, action: Selector?),
        secondaryButton: (title: String, emoji: String?, action: Selector?)? = nil,
        tertiaryButton: (title: String, emoji: String?, action: Selector?)? = nil,
        target: NSObject? = nil
    ) -> AlertViewController {
        let actualSecondary = secondaryButton?.title.isEmpty == true ? nil : secondaryButton
        let buttons = ButtonConfig.makeDefault(
            primary: primaryButton,
            secondary: actualSecondary,
            tertiary: tertiaryButton
        )
        return AlertViewController(title: title, message: message, buttons: buttons, style: .actionSheet, target: target)
    }
} 
