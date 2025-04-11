import UIKit

class FontManagerViewController: DefaultViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private var fonts: [GoogleFont] = []
    private var filteredFonts: [GoogleFont] = []
    private var downloadingFonts: Set<String> = []
    
    private enum LanguageFilter: String, CaseIterable {
        case all = "All"
        case latin = "Latin"
        case chinese = "Chinese"
        case japanese = "Japanese"
        case korean = "Korean"
        
        var title: String {
            switch self {
            case .all: return "所有字体"
            case .latin: return "拉丁字体"
            case .chinese: return "中文字体"
            case .japanese: return "日文字体"
            case .korean: return "韩文字体"
            }
        }
        
        var emoji: String {
            switch self {
            case .all: return "🌐"
            case .latin: return "🔤"
            case .chinese: return "🇨🇳"
            case .japanese: return "🇯🇵"
            case .korean: return "🇰🇷"
            }
        }
    }
    
    private var currentLanguageFilter: LanguageFilter = .all {
        didSet {
            filterFonts()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FontPreviewCell.self, forCellWithReuseIdentifier: FontPreviewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No fonts found"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupLanguageFilterButton()
        loadFonts()
    }
    
    private func setupUI() {
        title = "Fonts"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLanguageFilterButton() {
        let button = UIButton(type: .system)
        button.setTitle(currentLanguageFilter.emoji, for: .normal)
        button.titleLabel?.font = CustomFont.poppinsRegular.font(size: 20)
        button.addTarget(self, action: #selector(showLanguageFilterMenu), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func showLanguageFilterMenu() {
        let alertController = UIAlertController(title: "picker.choose_language".localized, message: nil, preferredStyle: .actionSheet)
        
        LanguageFilter.allCases.forEach { filter in
            let action = UIAlertAction(title: "\(filter.emoji) \(filter.title)", style: .default) { [weak self] _ in
                self?.currentLanguageFilter = filter
                if let button = self?.navigationItem.rightBarButtonItem?.customView as? UIButton {
                    button.setTitle(filter.emoji, for: .normal)
                }
            }
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        
        if let popoverController = alertController.popoverPresentationController,
           let buttonView = navigationItem.rightBarButtonItem?.customView {
            popoverController.sourceView = buttonView
            popoverController.sourceRect = buttonView.bounds
            popoverController.permittedArrowDirections = [.up, .down]
        }
        
        present(alertController, animated: true)
    }
    
    private func filterFonts() {
        let searchText = searchController.searchBar.text ?? ""
        
        filteredFonts = fonts.filter { font in
            let matchesSearch = searchText.isEmpty || font.family.lowercased().contains(searchText.lowercased())
            
            let matchesLanguage: Bool
            switch currentLanguageFilter {
            case .all:
                matchesLanguage = true
            case .latin:
                matchesLanguage = font.subsets.contains("latin")
            case .chinese:
                matchesLanguage = font.subsets.contains("chinese-simplified") ||
                                font.subsets.contains("chinese-traditional")
            case .japanese:
                matchesLanguage = font.subsets.contains("japanese")
            case .korean:
                matchesLanguage = font.subsets.contains("korean")
            }
            
            return matchesSearch && matchesLanguage
        }
        
        collectionView.reloadData()
        updateEmptyState()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Fonts"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func loadFonts() {
        Task {
            do {
                let fonts = try await FontDownloadManager.shared.searchFonts(query: "")
                self.fonts = fonts
                self.filteredFonts = fonts
                self.collectionView.reloadData()
                self.updateEmptyState()
            } catch {
                showError(error)
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(alert, animated: true)
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !filteredFonts.isEmpty
    }
}

// MARK: - UICollectionViewDataSource
extension FontManagerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFonts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FontPreviewCell.reuseIdentifier, for: indexPath) as? FontPreviewCell else {
            return UICollectionViewCell()
        }
        
        let font = filteredFonts[indexPath.item]
        let isDownloaded = FontDownloadManager.shared.getDownloadedFonts().keys.contains(font.family)
        cell.configure(with: font, isDownloaded: isDownloaded)
        
        cell.downloadTapped = { [weak self] in
            self?.downloadFont(font)
        }
        
        return cell
    }
    
    private func downloadFont(_ font: GoogleFont) {
        guard !downloadingFonts.contains(font.family) else { return }
        
        downloadingFonts.insert(font.family)
        if let cell = collectionView.visibleCells.first(where: { ($0 as? FontPreviewCell)?.getFontName() == font.family }) as? FontPreviewCell {
            cell.showLoading(true)
        }
        
        Task {
            do {
                let _ = try await FontDownloadManager.shared.downloadFont(font: font)
                downloadingFonts.remove(font.family)
                if let cell = collectionView.visibleCells.first(where: { ($0 as? FontPreviewCell)?.getFontName() == font.family }) as? FontPreviewCell {
                    cell.showLoading(false)
                }
                collectionView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name("FontDownloadedNotification"), object: nil, userInfo: ["fontFamily": font.family])
            } catch {
                downloadingFonts.remove(font.family)
                if let cell = collectionView.visibleCells.first(where: { ($0 as? FontPreviewCell)?.getFontName() == font.family }) as? FontPreviewCell {
                    cell.showLoading(false)
                }
                showError(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FontManagerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Accounting for section insets
        let font = filteredFonts[indexPath.item]
        
        // 根据字体是否支持多语言来决定高度
        let hasSecondaryText = font.subsets.contains("latin") && 
            (font.subsets.contains("chinese-simplified") || 
             font.subsets.contains("chinese-traditional") ||
             font.subsets.contains("japanese") ||
             font.subsets.contains("korean"))
         
        let height = hasSecondaryText ? 140 : 120
        return CGSizeMake(width, CGFloat(height))
    }
}

// MARK: - UISearchResultsUpdating
extension FontManagerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterFonts()
    }
} 
