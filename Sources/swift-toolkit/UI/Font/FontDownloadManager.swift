import Foundation
import UIKit

@MainActor
public class FontDownloadManager {
    public static let shared = FontDownloadManager()
    
    private let baseURL = "https://www.googleapis.com/webfonts/v1/webfonts"
    
    private var downloadedFonts: [String: URL] = [:]
    private var registeredFonts: Set<String> = []
    
    private init() {}
    
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
        
        // 移动字体文件到应用程序的文档目录
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("\(font.family).ttf")
        
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
            throw NSError(domain: "Font not found", code: -1, userInfo: [NSLocalizedDescriptionKey: "Font \(fontFamily) has not been downloaded"])
        }
        
        guard let fontData = try? Data(contentsOf: fontURL),
              let provider = CGDataProvider(data: fontData as CFData),
              let font = CGFont(provider) else {
            throw NSError(domain: "Font registration failed", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to register font \(fontFamily)"])
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            throw error?.takeRetainedValue() ?? NSError(domain: "Font registration failed", code: -1)
        }
        
        registeredFonts.insert(fontFamily)
    }
    
    // 注册所有已下载的字体
    public func registerAllDownloadedFonts() throws {
        for fontFamily in downloadedFonts.keys {
            if !registeredFonts.contains(fontFamily) {
                try registerFont(fontFamily: fontFamily)
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
    public func font(named fontFamily: String, size: CGFloat) -> UIFont? {
        guard isFontRegistered(fontFamily) else { return nil }
        return UIFont(name: fontFamily, size: size)
    }
    
    // 异步方法：获取字体
    public func fontAsync(named fontFamily: String, size: CGFloat) async -> UIFont {
        if let font = font(named: fontFamily, size: size) {
            return font
        }
        return .systemFont(ofSize: size)
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
