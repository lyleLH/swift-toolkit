import UIKit
import CoreText
import CoreGraphics
import WebKit

class FontPreviewCell: BaseCollectionViewCell {
    static let reuseIdentifier = "FontPreviewCell"
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        config.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = false
        webView.allowsLinkPreview = false
        return webView
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var downloadTapped: (() -> Void)?
    private var currentFont: GoogleFont?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addToContainer(contentStackView)
        
        contentStackView.addArrangedSubview(webView)
        contentStackView.addArrangedSubview(downloadButton)
        addToContainer(activityIndicator)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentStackView.superview!.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: contentStackView.superview!.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentStackView.superview!.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentStackView.superview!.bottomAnchor, constant: -8),
            
            // 确保 WebView 填充其在 StackView 中的空间
            webView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: downloadButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: downloadButton.centerYAnchor)
        ])
        
        // 设置 WebView 在 StackView 中的优先级
        webView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        webView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        downloadButton.setContentHuggingPriority(.required, for: .horizontal)
        downloadButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
    }
    
    @objc private func downloadButtonTapped() {
        downloadTapped?()
    }
    
    func configure(with font: GoogleFont, isDownloaded: Bool) {
        currentFont = font
        downloadButton.setImage(UIImage(systemName: isDownloaded ? "checkmark.circle.fill" : "arrow.down.circle"), for: .normal)
        downloadButton.tintColor = isDownloaded ? .systemGreen : .systemBlue
        
        if isDownloaded {
            if let fontURL = FontDownloadManager.shared.getDownloadedFonts()[font.family] {
                // 确保字体已注册
                do {
                    try FontDownloadManager.shared.registerFont(fontFamily: font.family)
                    loadLocalFont(from: fontURL, fontFamily: font.family)
                } catch {
                    print("Failed to register font: \(error)")
                    // 如果注册失败，回退到 Web 字体
                    loadWebFont(font)
                }
            }
        } else {
            loadWebFont(font)
        }
    }
    
    private func loadWebFont(_ font: GoogleFont) {
        let fontFamily = font.family.replacingOccurrences(of: " ", with: "+")
        
        // 获取示例文本
        let (primaryText, secondaryText) = getExampleTexts(for: font)
        let showSecondaryText = secondaryText != nil
        
        let html = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=\(fontFamily):wght@400;700&display=swap" rel="stylesheet">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                html, body {
                    height: 100%;
                    margin: 0;
                    padding: 0;
                    background-color: transparent;
                }
                body {
                    padding: 0 16px;
                    font-family: '\(font.family)', sans-serif;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                }
                .font-name {
                    font-size: 18px;
                    font-weight: 700;
                    margin-bottom: 4px;
                    padding-right: 48px;
                    color: var(--text-color);
                }
                .preview-text {
                    font-size: 15px;
                    font-weight: 400;
                    color: var(--text-color);
                    opacity: 0.8;
                }
                .secondary-text {
                    font-size: 13px;
                    font-weight: 400;
                    color: var(--text-color);
                    opacity: 0.6;
                    margin-top: 4px;
                }
                @media (prefers-color-scheme: dark) {
                    :root {
                        --text-color: #FFFFFF;
                    }
                }
                @media (prefers-color-scheme: light) {
                    :root {
                        --text-color: #000000;
                    }
                }
            </style>
        </head>
        <body>
            <div class="font-name">\(font.family)</div>
            <div class="preview-text">\(primaryText)</div>
            \(secondaryText.map { "<div class=\"secondary-text\">\($0)</div>" } ?? "")
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: URL(string: "https://fonts.googleapis.com"))
    }
    
    private func loadLocalFont(from url: URL, fontFamily: String) {
        // 获取示例文本
        let (primaryText, secondaryText) = getExampleTexts(for: currentFont)
        let showSecondaryText = secondaryText != nil
        
        let html = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                html, body {
                    height: 100%;
                    margin: 0;
                    padding: 0;
                    background-color: transparent;
                }
                body {
                    padding: 0 16px;
                    font-family: '\(fontFamily)', -apple-system, sans-serif;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                }
                .font-name {
                    font-size: 18px;
                    font-weight: 700;
                    margin-bottom: 4px;
                    padding-right: 48px;
                    color: var(--text-color);
                }
                .preview-text {
                    font-size: 15px;
                    line-height: 1.4;
                    color: var(--text-color);
                    margin-bottom: \(showSecondaryText ? "4px" : "0");
                }
                .secondary-text {
                    font-size: 15px;
                    line-height: 1.4;
                    color: var(--text-color);
                    opacity: 0.7;
                }
                @media (prefers-color-scheme: dark) {
                    :root {
                        --text-color: #FFFFFF;
                    }
                }
                @media (prefers-color-scheme: light) {
                    :root {
                        --text-color: #000000;
                    }
                }
            </style>
        </head>
        <body>
            <div class="font-name">\(fontFamily)</div>
            <div class="preview-text">\(primaryText)</div>
            \(secondaryText.map { "<div class=\"secondary-text\">\($0)</div>" } ?? "")
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    private func getExampleTexts(for font: GoogleFont?) -> (primary: String, secondary: String?) {
        guard let font = font else {
            return ("The quick brown fox jumps over the lazy dog", nil)
        }
        
        let subsets = font.subsets
        
        // 确定主要语言和次要语言
        if subsets.contains("chinese-simplified") || subsets.contains("chinese-traditional") {
            if subsets.contains("latin") {
                return ("春花秋月何时了，往事知多少。", "The quick brown fox jumps over the lazy dog")
            }
            return ("春花秋月何时了，往事知多少。", nil)
        }
        
        if subsets.contains("japanese") {
            if subsets.contains("latin") {
                return ("いろはにほへと ちりぬるを", "The quick brown fox jumps over the lazy dog")
            }
            return ("いろはにほへと ちりぬるを", nil)
        }
        
        if subsets.contains("korean") {
            if subsets.contains("latin") {
                return ("다람쥐 헌 쳇바퀴에 타고파", "The quick brown fox jumps over the lazy dog")
            }
            return ("다람쥐 헌 쳇바퀴에 타고파", nil)
        }
        
        return ("The quick brown fox jumps over the lazy dog", nil)
    }
    
    func showLoading(_ show: Bool) {
        downloadButton.isHidden = show
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func getFontName() -> String? {
        return currentFont?.family
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        webView.loadHTMLString("", baseURL: nil)
        downloadButton.isHidden = false
        activityIndicator.stopAnimating()
    }
} 