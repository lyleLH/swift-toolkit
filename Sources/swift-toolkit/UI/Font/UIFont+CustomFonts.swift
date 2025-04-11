import UIKit

@MainActor
public extension UIFont {
    /// 使用下载的字体创建 UIFont 实例
    /// - Parameters:
    ///   - family: 字体家族名称
    ///   - size: 字体大小
    /// - Returns: 如果字体已下载并注册，返回对应的 UIFont 实例；否则返回系统字体
    static func customFont(family: String, size: CGFloat) -> UIFont {
        if let font = FontDownloadManager.shared.font(named: family, size: size) {
            return font
        }
        return .systemFont(ofSize: size)
    }
    
    /// 异步方法：使用下载的字体创建 UIFont 实例
    /// - Parameters:
    ///   - family: 字体家族名称
    ///   - size: 字体大小
    /// - Returns: 如果字体已下载并注册，返回对应的 UIFont 实例；否则返回系统字体
    static func customFontAsync(family: String, size: CGFloat) async -> UIFont {
        return await FontDownloadManager.shared.fontAsync(named: family, size: size)
    }
    
    /// 使用下载的字体创建粗体 UIFont 实例
    /// - Parameters:
    ///   - family: 字体家族名称
    ///   - size: 字体大小
    /// - Returns: 如果字体已下载并注册，返回对应的粗体 UIFont 实例；否则返回系统粗体字体
    static func customBoldFont(family: String, size: CGFloat) -> UIFont {
        if let font = FontDownloadManager.shared.font(named: family, size: size) {
            return font
        }
        return .boldSystemFont(ofSize: size)
    }
    
    /// 异步方法：使用下载的字体创建粗体 UIFont 实例
    /// - Parameters:
    ///   - family: 字体家族名称
    ///   - size: 字体大小
    /// - Returns: 如果字体已下载并注册，返回对应的粗体 UIFont 实例；否则返回系统粗体字体
    static func customBoldFontAsync(family: String, size: CGFloat) async -> UIFont {
        let font = await FontDownloadManager.shared.fontAsync(named: family, size: size)
        return font.withTraits(.traitBold)
    }
}

private extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor ?? fontDescriptor, size: pointSize)
    }
} 