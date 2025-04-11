#if canImport(UIKit)
import UIKit
import ProgressHUD

@available(iOS 16.0, *)
@MainActor public class HUD {
    /// 显示加载提示
    /// - Parameters:
    ///   - text: 提示文本
    ///   - interaction: 是否允许用户交互
    public static func showLoading(_ text: String? = nil, interaction: Bool = true) {
        if let text = text {
            ProgressHUD.animate(text, interaction: interaction)
        } else {
            ProgressHUD.animate(interaction: interaction)
        }
    }
    
    /// 显示成功提示
    /// - Parameters:
    ///   - text: 提示文本
    ///   - delay: 自动消失延迟时间
    public static func showSuccess(_ text: String? = nil, delay: TimeInterval = 1.5) {
        if let text = text {
            ProgressHUD.succeed(text, delay: delay)
        } else {
            ProgressHUD.succeed(delay: delay)
        }
    }
    
    /// 显示错误提示
    /// - Parameters:
    ///   - text: 提示文本
    ///   - delay: 自动消失延迟时间
    public static func showError(_ text: String? = nil, delay: TimeInterval = 1.5) {
        if let text = text {
            ProgressHUD.failed(text, delay: delay)
        } else {
            ProgressHUD.failed(delay: delay)
        }
    }
    
    /// 显示进度
    /// - Parameters:
    ///   - text: 提示文本
    ///   - progress: 进度值（0-1）
    public static func showProgress(_ text: String? = nil, progress: Float) {
        if let text = text {
            ProgressHUD.progress(text, CGFloat(progress))
        } else {
            ProgressHUD.progress(CGFloat(progress))
        }
    }
    
    /// 显示自定义图标
    /// - Parameters:
    ///   - text: 提示文本
    ///   - symbolName: SF Symbols名称
    public static func showSymbol(_ text: String? = nil, symbolName: String) {
        if let text = text {
            ProgressHUD.symbol(text, name: symbolName)
        } else {
            ProgressHUD.symbol(name: symbolName)
        }
    }
    
    /// 隐藏HUD
    public static func hide() {
        ProgressHUD.dismiss()
    }
    
    /// 移除HUD
    public static func remove() {
        ProgressHUD.remove()
    }
    
    /// 配置HUD样式
    public static func configure() {
        // 设置动画类型
        ProgressHUD.animationType = .circleStrokeSpin
        
        // 设置颜色
        ProgressHUD.colorHUD = .systemGray
        ProgressHUD.colorBackground = .lightGray
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.colorStatus = .label
        
        // 设置尺寸
        ProgressHUD.mediaSize = 50
        ProgressHUD.marginSize = 20
        
        // 设置字体
        ProgressHUD.fontStatus = .systemFont(ofSize: 16)
    }
}
#endif 
