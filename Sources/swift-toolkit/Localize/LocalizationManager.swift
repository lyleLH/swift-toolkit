import Foundation

@preconcurrency final class LocalizationManager {
    @MainActor static let shared = LocalizationManager()
    
    private var bundle: Bundle?
    private let defaultLanguage = "en"
    
    private init() {
        // Initialize with current language
        if let language = UserDefaults.standard.string(forKey: "AppleLanguages") {
            setupLocalizationBundle(for: language)
        }
    }
    
    /// Returns the localized string for the given key
    /// - Parameter key: The key to look up in Localizable.strings
    /// - Parameter comment: A comment to provide context for translators
    /// - Returns: The localized string
    func localizedString(_ key: String, comment: String = "") -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) 
            ?? Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    }
    
    /// Changes the app's language
    /// - Parameter language: The language code (e.g., "en", "zh-Hans", "ja")
    func setLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        setupLocalizationBundle(for: language)
        
        // Post notification for views to update
        NotificationCenter.default.post(name: Notification.Name("languageDidChange"), object: nil)
    }
    
    /// Gets the current app language
    /// - Returns: The current language code
    func getCurrentLanguage() -> String {
        return UserDefaults.standard.string(forKey: "AppleLanguages") ?? defaultLanguage
    }
    
    /// Setup the localization bundle for the specified language
    private func setupLocalizationBundle(for language: String) {
        guard let languageBundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
              let languageBundle = Bundle(path: languageBundlePath) else {
            bundle = nil
            return
        }
        bundle = languageBundle
    }
    
    /// Get all supported languages
    func getSupportedLanguages() -> [(code: String, name: String)] {
        let languages = Bundle.main.localizations.filter { $0 != "Base" }
        return languages.map { code in
            let locale = Locale(identifier: code)
            let name = locale.localizedString(forLanguageCode: code) ?? code
            return (code, name)
        }
    }
}

// MARK: - Convenience Extension
extension String {
    @MainActor var localized: String {
        return LocalizationManager.shared.localizedString(self)
    }
} 
