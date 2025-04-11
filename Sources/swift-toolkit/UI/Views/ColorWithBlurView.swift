import UIKit

class ColorWithBlurView: UIView {
    // MARK: - Properties
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var blurView: DefaultBlurView = {
        let view = DefaultBlurView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.usingWhiteEffect()
        return view
    }()
    
    // MARK: - Public Properties
    var color: UIColor = .systemBackground.withAlphaComponent(0.6) {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // 添加 colorView
        addSubview(colorView)
        // 添加阴影效果
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOffset = CGSize(width: 0, height: 2)
        colorView.layer.shadowRadius = 4
        colorView.layer.shadowOpacity = 0.1
        // 添加 blurView
        addSubview(blurView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // colorView 填充整个容器
            colorView.topAnchor.constraint(equalTo: topAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // blurView 填充整个容器
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 设置默认颜色
        colorView.backgroundColor = color
    }
    
    // MARK: - Public Methods
    func updateBlurIntensity(_ intensity: CGFloat) {
        blurView.alpha = intensity
    }
    
    func setBlurHidden(_ hidden: Bool, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.blurView.alpha = hidden ? 0 : 1
            }
        } else {
            blurView.alpha = hidden ? 0 : 1
        }
    }
} 
