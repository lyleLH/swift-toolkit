import UIKit

public extension UIButton {
    public enum ConfirmationStyle {
        case primary
        case destructive
        case cancel
        
        public var backgroundColor: UIColor {
            switch self {
            case .primary:
                return .mainGreen
            case .destructive:
                return .systemRed
            case .cancel:
                return .systemGray5
            }
        }
        
        public var titleColor: UIColor {
            switch self {
            case .cancel:
                return .label
            case .primary, .destructive:
                return .white
            }
        }
    }
    
    public static func makeConfirmationButton(
        title: String,
        emoji: String?,
        style: ConfirmationStyle
    ) -> UIButton {
        let button = UIButton.makeTwEmojiButton(emoji: emoji ?? "", size: CGSize(width: 28, height: 28))

        // 设置标题
        var title = title
        if let emoji = emoji {
            title = "  \(title)"
        }
        button.setTitle(title, for: .normal)
        button.setTitleColor(style.titleColor, for: .normal)
        
        // 设置样式
        button.backgroundColor = style.backgroundColor
        button.layer.cornerRadius = 10
        
        return button
    }
}
