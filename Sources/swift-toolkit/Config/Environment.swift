import Foundation

public enum Environment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    // MARK: - API Keys
    public static var googleFontsAPIKey: String {
        // 1. 首先尝试从环境变量获取
        if let key = ProcessInfo.processInfo.environment["GOOGLE_FONTS_API_KEY"] {
            return key
        }
        
        // 2. 然后尝试从 Info.plist 获取
        if let key = infoDictionary["GOOGLE_FONTS_API_KEY"] as? String {
            return key
        }
        
        // 3. 如果都没有，返回空字符串并打印警告
        print("⚠️ Warning: GOOGLE_FONTS_API_KEY not found in environment variables or Info.plist")
        return ""
    }
    
    // MARK: - Environment Variables
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    public static var isProduction: Bool {
        return !isDebug
    }
} 