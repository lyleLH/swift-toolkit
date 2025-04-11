import UIKit

public enum CustomFont: String {
    // 中文字体
    case huiwenRegular = "Huiwen-mincho"
    
    // Poppins
    case poppinsRegular = "Poppins-Regular"
    case poppinsMedium = "Poppins-Medium"
    case poppinsSemiBold = "Poppins-SemiBold"
    case poppinsBold = "Poppins-Bold"
    case poppinsExtraBold = "Poppins-ExtraBold"
    
    public func font(size: CGFloat) -> UIFont {
        if let customFont = UIFont(name: self.rawValue, size: size) {
//            print("✅ 成功加载字体: \(self.rawValue)")
            return customFont
        }
//        print("⚠️ 字体加载失败: \(self.rawValue)，使用系统字体代替")
        return .systemFont(ofSize: size)
    }
}
