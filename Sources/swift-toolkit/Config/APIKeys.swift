import Foundation

public enum APIKeys {
    private static let googleFontsAPIKey: String = {
        // 从环境变量中获取 API key
        if let key = ProcessInfo.processInfo.environment["GOOGLE_FONTS_API_KEY"] {
            return key
        }
        // 如果环境变量不存在，返回空字符串
        return ""
    }()
    
    public static func getGoogleFontsAPIKey() -> String {
        return googleFontsAPIKey
    }
} 