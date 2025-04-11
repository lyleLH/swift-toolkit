import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var blurView: DefaultBlurView = {
        let view = DefaultBlurView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.usingWhiteEffect()
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBaseViews() {
        contentView.addSubview(colorView)
        contentView.addSubview(blurView)
        contentView.addSubview(containerView)
        
        // 添加阴影效果
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOffset = CGSize(width: 0, height: 2)
        colorView.layer.shadowRadius = 4
        colorView.layer.shadowOpacity = 0.1
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            blurView.topAnchor.constraint(equalTo: colorView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: blurView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)
        ])
    }
    
    // 提供一个方法让子类可以访问 containerView
    func addToContainer(_ view: UIView) {
        containerView.addSubview(view)
    }
    
    // 提供一个方法让子类可以自定义圆角
    func customizeCornerRadius(_ radius: CGFloat) {
        colorView.layer.cornerRadius = radius
        blurView.layer.cornerRadius = radius
        containerView.layer.cornerRadius = radius
    }
} 
