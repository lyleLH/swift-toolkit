import UIKit

public final class FontManager: Sendable {
    public static let shared = FontManager()
    
    private init() {}
    
    // MARK: - Font Registration
    public static func registerFonts() {
        // 打印所有可用的字体名称，用于调试
        print("系统所有字体:")
        UIFont.familyNames.forEach { familyName in
            print("Family: \(familyName)")
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print("-- Font: \(fontName)")
            }
        }
        
        // 支持 otf 和 ttf 格式
        let extensions = ["otf", "ttf"]
        extensions.forEach { fileExtension in
            guard let urls = Bundle.main.urls(forResourcesWithExtension: fileExtension, subdirectory: nil) else {
                print("⚠️ 没有在 Bundle 中找到 .\(fileExtension) 字体文件")
                return
            }
            
            print("找到以下 .\(fileExtension) 字体文件:")
            urls.forEach { print($0.lastPathComponent) }
            
            urls.forEach { url in
                guard let dataProvider = CGDataProvider(url: url as CFURL) else {
                    print("⚠️ 无法创建 CGDataProvider for \(url.lastPathComponent)")
                    return
                }
                guard let font = CGFont(dataProvider) else {
                    print("⚠️ 无法创建 CGFont for \(url.lastPathComponent)")
                    return
                }
                
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    print("⚠️ 注册字体失败: \(url.lastPathComponent)")
                    if let error = error?.takeUnretainedValue() {
                        print("错误信息: \(error)")
                    }
                } else {
                    print("✅ 成功注册字体: \(url.lastPathComponent)")
                }
            }
        }
    }
    
    // MARK: - Font Styles
    public func poppinsFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let font: CustomFont
        switch weight {
        case .regular:
            font = .poppinsRegular
        case .medium:
            font = .poppinsMedium
        case .semibold:
            font = .poppinsSemiBold
        case .bold:
            font = .poppinsBold
        default:
            font = .poppinsRegular
        }
        
        return font.font(size: size)
    }
    
    // MARK: - Common Font Styles
    public var titleFont: UIFont {
        return poppinsFont(ofSize: 24, weight: .bold)
    }
    
    public var subtitleFont: UIFont {
        return poppinsFont(ofSize: 16, weight: .medium)
    }
    
    public var bodyFont: UIFont {
        return poppinsFont(ofSize: 14, weight: .regular)
    }
    
    public var headerFont: UIFont {
        return poppinsFont(ofSize: 18, weight: .semibold)
    }
    
    public var headerSubtitleFont: UIFont {
        return poppinsFont(ofSize: 14, weight: .regular)
    }
} 
