import Foundation

@MainActor
class FontDownloadManager {
    static let shared = FontDownloadManager()
    
    private let googleFontsAPIKey = "AIzaSyAs2o2XHqo_3lOJGC-CczbyAX3-wdGaFqE"
    private let baseURL = "https://www.googleapis.com/webfonts/v1/webfonts"
    
    private var downloadedFonts: [String: URL] = [:]
    
    private init() {}
    
    // 搜索字体
    func searchFonts(query: String) async throws -> [GoogleFont] {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: googleFontsAPIKey),
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
    func downloadFont(font: GoogleFont) async throws -> URL {
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
    
    // 获取已下载的字体列表
    func getDownloadedFonts() -> [String: URL] {
        return downloadedFonts
    }
}

// 数据模型
struct GoogleFontsResponse: Codable {
    let items: [GoogleFont]
    let kind: String
}

struct GoogleFont: Codable {
    let family: String
    let files: [String: String]
    let category: String
    let kind: String
    let version: String
    let lastModified: String
    let variants: [String]
    let subsets: [String]
    
    var regularFontURL: String? {
        return files["regular"] ?? files["400"]
    }
} 
