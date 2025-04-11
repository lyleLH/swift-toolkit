import Foundation
import UIKit
import CoreText
import CoreGraphics

public enum FontError: LocalizedError {
    case fontNotFound(String)
    case fontRegistrationFailed(String)
    case invalidURL(String)
    case apiKeyMissing
    
    public var errorDescription: String? {
        switch self {
        case .fontNotFound(let family):
            return "Font \(family) has not been downloaded"
        case .fontRegistrationFailed(let family):
            return "Failed to register font \(family)"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .apiKeyMissing:
            return "Google Fonts API key is missing"
        }
    }
}

@MainActor
public class FontDownloadManager {
    public static let shared = FontDownloadManager()
    
    private let baseURL = "https://www.googleapis.com/webfonts/v1/webfonts"
    private let registeredFontsKey = "com.swift-toolkit.registeredFonts"
    
    private var downloadedFonts: [String: URL] = [:]
    private var registeredFonts: Set<String> = []
    
    private var fontsDirectoryURL: URL {
        let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupport.appendingPathComponent("Fonts")
    }
    
    private init() {
        // 从 UserDefaults 恢复已注册的字体
        if let savedFonts = UserDefaults.standard.stringArray(forKey: registeredFontsKey) {
            registeredFonts = Set(savedFonts)
        }
        
        // 确保字体目录存在
        createFontsDirectoryIfNeeded()
        
        // 加载已下载的字体
        loadDownloadedFonts()
        
        // 注册所有已下载的字体
        do {
            try registerAllDownloadedFonts()
        } catch {
            print("Failed to register fonts: \(error)")
        }
    }
    
    private func createFontsDirectoryIfNeeded() {
        do {
            try FileManager.default.createDirectory(at: fontsDirectoryURL, withIntermediateDirectories: true)
        } catch {
            print("Failed to create fonts directory: \(error)")
        }
    }
    
    private func loadDownloadedFonts() {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: fontsDirectoryURL, includingPropertiesForKeys: nil)
            for url in fileURLs where url.pathExtension == "ttf" {
                let fontName = url.deletingPathExtension().lastPathComponent
                downloadedFonts[fontName] = url
            }
        } catch {
            print("Failed to load downloaded fonts: \(error)")
        }
    }
    
    private func saveRegisteredFonts() {
        UserDefaults.standard.set(Array(registeredFonts), forKey: registeredFontsKey)
    }
    
    // 搜索字体
    public func searchFonts(query: String) async throws -> [GoogleFont] {
        let apiKey = Environment.googleFontsAPIKey
        guard !apiKey.isEmpty else {
            throw NSError(domain: "API Key Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google Fonts API key is missing"])
        }
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "sort", value: "popularity")
        ]
        
        guard let url = components?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(GoogleFontsResponse.self, from: data)
        return response.items.filter { font in
            query.isEmpty || font.family.lowercased().contains(query.lowercased())
        }
    }
    
    // 下载字体
    public func downloadFont(font: GoogleFont) async throws -> URL {
        guard let fontURL = font.regularFontURL,
              let url = URL(string: fontURL) else {
            throw NSError(domain: "Invalid font URL", code: -1)
        }
        
        let (localURL, _) = try await URLSession.shared.download(from: url)
        
        // 移动字体文件到字体目录
        let destinationURL = fontsDirectoryURL.appendingPathComponent("\(font.family).ttf")
        
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
        try FileManager.default.moveItem(at: localURL, to: destinationURL)
        downloadedFonts[font.family] = destinationURL
        return destinationURL
    }
    
    // 注册字体
    public func registerFont(fontFamily: String) throws {
        guard let fontURL = downloadedFonts[fontFamily] else {
            throw FontError.fontNotFound(fontFamily)
        }
        
        // 如果字体已经注册，直接返回
        if registeredFonts.contains(fontFamily) {
            return
        }
        
        do {
            let fontData = try Data(contentsOf: fontURL)
            if let dataProvider = CGDataProvider(data: fontData as CFData),
               let cgFont = CGFont(dataProvider) {
                var error: Unmanaged<CFError>?
                if CTFontManagerRegisterGraphicsFont(cgFont, &error) {
                    registeredFonts.insert(fontFamily)
                    saveRegisteredFonts()
                } else {
                    throw FontError.fontRegistrationFailed(fontFamily)
                }
            } else {
                throw FontError.fontRegistrationFailed(fontFamily)
            }
        } catch {
            throw FontError.fontRegistrationFailed(fontFamily)
        }
    }
    
    // 注册所有已下载的字体
    public func registerAllDownloadedFonts() throws {
        for (fontFamily, _) in downloadedFonts {
            do {
                try registerFont(fontFamily: fontFamily)
            } catch {
                print("Failed to register font \(fontFamily): \(error)")
                throw error
            }
        }
    }
    
    // 获取已下载的字体列表
    public func getDownloadedFonts() -> [String: URL] {
        return downloadedFonts
    }
    
    // 检查字体是否已注册
    public func isFontRegistered(_ fontFamily: String) -> Bool {
        return registeredFonts.contains(fontFamily)
    }
    
    // 便捷方法：获取已注册的字体
    public func font(named fontFamily: String, size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont? {
        // 获取该字体家族的所有可用字体名称
        let availableFonts = UIFont.fontNames(forFamilyName: fontFamily)
        
        // 根据权重选择最合适的字体名称
        let fontName = selectFontName(from: availableFonts, weight: weight)
        
        // 如果找到了合适的字体名称，创建字体
        if let name = fontName {
            return UIFont(name: name, size: size)
        }
        
        return nil
    }
    
    private func selectFontName(from fontNames: [String], weight: UIFont.Weight) -> String? {
        // 根据权重选择最合适的字体名称
        switch weight {
        case .ultraLight:
            return fontNames.first { $0.contains("UltraLight") || $0.contains("Thin") }
        case .thin:
            return fontNames.first { $0.contains("Thin") }
        case .light:
            return fontNames.first { $0.contains("Light") }
        case .regular:
            return fontNames.first { $0.contains("Regular") || !$0.contains(" ") }
        case .medium:
            return fontNames.first { $0.contains("Medium") }
        case .semibold:
            return fontNames.first { $0.contains("SemiBold") || $0.contains("DemiBold") }
        case .bold:
            return fontNames.first { $0.contains("Bold") }
        case .heavy:
            return fontNames.first { $0.contains("Heavy") }
        case .black:
            return fontNames.first { $0.contains("Black") }
        default:
            return fontNames.first
        }
    }
    
    // 异步方法：获取字体
    public func fontAsync(named fontFamily: String, size: CGFloat, weight: UIFont.Weight = .regular) async -> UIFont {
        if let font = font(named: fontFamily, size: size, weight: weight) {
            return font
        }
        return .systemFont(ofSize: size, weight: weight)
    }
    
    public static func setupFonts() {
        do {
            try shared.registerAllDownloadedFonts()
        } catch {
            print("Failed to register fonts: \(error)")
        }
    }
    
    public func getRegisteredFonts() -> Set<String> {
        return registeredFonts
    }
}

// 数据模型
public struct GoogleFontsResponse: Codable {
    public let items: [GoogleFont]
    public let kind: String
    
    public init(items: [GoogleFont], kind: String) {
        self.items = items
        self.kind = kind
    }
}

public struct GoogleFont: Codable {
    public let family: String
    public let files: [String: String]
    public let category: String
    public let kind: String
    public let version: String
    public let lastModified: String
    public let variants: [String]
    public let subsets: [String]
    
    public var regularFontURL: String? {
        return files["regular"] ?? files["400"]
    }
    
    public init(family: String, files: [String: String], category: String, kind: String, version: String, lastModified: String, variants: [String], subsets: [String]) {
        self.family = family
        self.files = files
        self.category = category
        self.kind = kind
        self.version = version
        self.lastModified = lastModified
        self.variants = variants
        self.subsets = subsets
    }
}
