#if canImport(UIKit)
import UIKit

public extension UIView {
    /// 为视图添加圆角
    /// - Parameter radius: 圆角半径
    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// 为视图添加阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - radius: 阴影半径
    ///   - offset: 阴影偏移
    ///   - opacity: 阴影透明度
    func addShadow(color: UIColor = .black,
                  radius: CGFloat = 3,
                  offset: CGSize = .zero,
                  opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
    
    /// 为视图添加边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    func addBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
#endif 