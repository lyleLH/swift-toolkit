//
//  UIImage+Twemoji.swift
//  FlyerCard
//
//  Created by hao92 on 2024-12-16.
//

import UIKit
import TwemojiKit
import SVGKit

private actor TwemojiTaskManager {
    static let shared = TwemojiTaskManager()
    private var loadingTasks: [String: Task<UIImage, Error>] = [:]
    private var failedKeys = Set<String>()
    
    func getExistingTask(for emoji: String) -> Task<UIImage, Error>? {
        return loadingTasks[emoji]
    }
    
    func storeTask(_ task: Task<UIImage, Error>, for emoji: String) {
        loadingTasks[emoji] = task
    }
    
    func removeTask(for emoji: String) {
        loadingTasks.removeValue(forKey: emoji)
    }
    
    func markAsFailed(_ key: String) {
        failedKeys.insert(key)
    }
    
    func shouldRetry(_ key: String) -> Bool {
        return failedKeys.remove(key) != nil
    }
}

public extension UIImage {
    private static let cacheFolderName = "TwemojiCache"
    private static let maxConcurrentLoads = 5
    private static let loadSemaphore = DispatchSemaphore(value: maxConcurrentLoads)
    private static let loadQueue = DispatchQueue(label: "com.flyercard.twemoji.load", attributes: .concurrent)
    private static let standardSize = CGSize(width: 512, height: 512)
    private static let thumbnailSize = CGSize(width: 64, height: 64)
    
    private static func getCacheKey(emoji: String, isStandard: Bool) -> String {
        // 获取emoji的Unicode码点
        let unicodeScalars = emoji.unicodeScalars.map { String(format: "%04X", $0.value) }.joined()
        let suffix = isStandard ? "_standard" : "_thumbnail"
        return "twemoji_\(unicodeScalars)\(suffix)"
    }
    
    private static func getCacheDirectory() -> URL? {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let twemojiCacheDir = cacheDir.appendingPathComponent(cacheFolderName)
        
        if !FileManager.default.fileExists(atPath: twemojiCacheDir.path) {
            try? FileManager.default.createDirectory(at: twemojiCacheDir, withIntermediateDirectories: true)
        }
        
        return twemojiCacheDir
    }
    
    private static func getCachedImage(for emoji: String, isStandard: Bool) -> UIImage? {
        guard let cacheDir = getCacheDirectory() else { return nil }
        let cacheKey = getCacheKey(emoji: emoji, isStandard: isStandard)
        let cacheFile = cacheDir.appendingPathComponent("\(cacheKey).png")
        guard let data = try? Data(contentsOf: cacheFile) else { return nil }
        return UIImage(data: data)
    }
    
    private static func cacheImage(_ image: UIImage, for emoji: String, isStandard: Bool) {
        guard let cacheDir = getCacheDirectory() else { return }
        let cacheKey = getCacheKey(emoji: emoji, isStandard: isStandard)
        let cacheFile = cacheDir.appendingPathComponent("\(cacheKey).png")
        try? image.pngData()?.write(to: cacheFile)
    }
    
    private static func getCachedSVGData(for emoji: String) -> Data? {
        guard let cacheDir = getCacheDirectory() else { return nil }
        let cacheKey = getCacheKey(emoji: emoji, isStandard: true)
        let cacheFile = cacheDir.appendingPathComponent("\(cacheKey).svg")
        return try? Data(contentsOf: cacheFile)
    }
    
    private static func cacheSVGData(_ data: Data, for emoji: String) {
        guard let cacheDir = getCacheDirectory() else { return }
        let cacheKey = getCacheKey(emoji: emoji, isStandard: true)
        let cacheFile = cacheDir.appendingPathComponent("\(cacheKey).svg")
        try? data.write(to: cacheFile)
    }
    
    @MainActor
    static func loadTwEmoji(emoji: String, size: CGSize, forThumbnail: Bool = false) async throws -> UIImage {
        let targetSize = forThumbnail ? thumbnailSize : standardSize
        let cacheKey = getCacheKey(emoji: emoji, isStandard: !forThumbnail)
        
        // 检查是否需要重试
        let shouldRetry = await TwemojiTaskManager.shared.shouldRetry(cacheKey)
        
        // 如果不需要重试，尝试从缓存加载
        if !shouldRetry {
            // 检查是否已经有相同的加载任务
            if let existingTask = await TwemojiTaskManager.shared.getExistingTask(for: cacheKey) {
                let image = try await existingTask.value
                return image.resize(targetSize: size)
            }
            
            // 尝试从缓存加载
            if let cachedImage = getCachedImage(for: emoji, isStandard: !forThumbnail) {
                return cachedImage.resize(targetSize: size)
            }
            
            // 尝试从SVG缓存加载
            if let cachedData = getCachedSVGData(for: emoji),
               let source = SVGKSourceNSData.source(from: cachedData, urlForRelativeLinks: nil),
               let svgImage = SVGKImage(source: source) {
                svgImage.size = targetSize
                if let image = svgImage.uiImage {
                    // 缓存生成的图像
                    cacheImage(image, for: emoji, isStandard: !forThumbnail)
                    return image.resize(targetSize: size)
                }
            }
        }
        
        // 创建新的加载任务
        let task = Task<UIImage, Error> { @MainActor in
            // 限制并发数量
            await withCheckedContinuation { continuation in
                loadQueue.async {
                    loadSemaphore.wait()
                    continuation.resume()
                }
            }
            
            defer {
                loadSemaphore.signal()
            }
            
            do {
                // 如果缓存中没有，则从网络加载
                let twemoji = Twemoji()
                guard let originalURL = twemoji.parse(emoji).first?.imageURL,
                      var urlComponents = URLComponents(url: originalURL, resolvingAgainstBaseURL: true) else {
                    await TwemojiTaskManager.shared.markAsFailed(cacheKey)
                    return createEmojiImage(from: emoji, size: size)
                }
                
                // 修改 URL 以使用 SVG 路径
                urlComponents.scheme = "https"
                urlComponents.host = "cdn.jsdelivr.net"
                urlComponents.path = urlComponents.path
                    .replacingOccurrences(of: "/72x72/", with: "/svg/")
                    .replacingOccurrences(of: ".png", with: ".svg")
                
                guard let url = urlComponents.url else {
                    await TwemojiTaskManager.shared.markAsFailed(cacheKey)
                    return createEmojiImage(from: emoji, size: size)
                }
                
                // 添加重试机制
                var retryCount = 3
                var lastError: Error?
                
                while retryCount > 0 {
                    do {
                        let (data, response) = try await URLSession.shared.data(from: url)
                        
                        guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            retryCount -= 1
                            continue
                        }
                        
                        // 缓存下载的SVG数据
                        cacheSVGData(data, for: emoji)
                        
                        // 创建SVG源
                        let source = SVGKSourceNSData.source(from: data, urlForRelativeLinks: url)
                        guard let svgImage = SVGKImage(source: source) else {
                            await TwemojiTaskManager.shared.markAsFailed(cacheKey)
                            return createEmojiImage(from: emoji, size: size)
                        }
                        
                        // 设置SVG图像的尺寸
                        svgImage.size = targetSize
                        
                        // 获取UIImage并缓存
                        guard let image = svgImage.uiImage else {
                            await TwemojiTaskManager.shared.markAsFailed(cacheKey)
                            return createEmojiImage(from: emoji, size: size)
                        }
                        
                        // 缓存生成的图像
                        cacheImage(image, for: emoji, isStandard: !forThumbnail)
                        
                        // 如果是标准尺寸，同时生成并缓存缩略图
                        if !forThumbnail {
                            svgImage.size = thumbnailSize
                            if let thumbnailImage = svgImage.uiImage {
                                cacheImage(thumbnailImage, for: emoji, isStandard: false)
                            }
                        }
                        
                        return image.resize(targetSize: size)
                    } catch {
                        lastError = error
                        retryCount -= 1
                        if retryCount > 0 {
                            try await Task.sleep(nanoseconds: UInt64(1_000_000_000)) // 1秒延迟
                        }
                    }
                }
                
                await TwemojiTaskManager.shared.markAsFailed(cacheKey)
                return createEmojiImage(from: emoji, size: size)
                
            } catch {
                await TwemojiTaskManager.shared.markAsFailed(cacheKey)
                return createEmojiImage(from: emoji, size: size)
            }
        }
        
        // 保存任务引用
        await TwemojiTaskManager.shared.storeTask(task, for: cacheKey)
        
        do {
            let result = try await task.value
            await TwemojiTaskManager.shared.removeTask(for: cacheKey)
            return result
        } catch {
            await TwemojiTaskManager.shared.removeTask(for: cacheKey)
            throw error
        }
    }
    
    @MainActor private static func createEmojiImage(from emoji: String, size: CGSize) -> UIImage {
        let label = UILabel(frame: CGRect(origin: .zero, size: size))
        label.font = .systemFont(ofSize: min(size.width, size.height) * 0.8)
        label.text = emoji
        label.textAlignment = .center
        label.backgroundColor = .clear
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        if let context = UIGraphicsGetCurrentContext() {
            label.layer.render(in: context)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                return image
            }
        }
        
        // 如果转换失败，返回一个空白图片
        return UIImage()
    }
}
 
