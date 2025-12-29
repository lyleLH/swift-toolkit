import UIKit

open class MTTabBarController: PTCardTabBarController {
    
    public struct TabItemConfig {
        public let viewController: UIViewController
        public let title: String
        public let image: UIImage?
        public let selectedImage: UIImage?
        
        public init(viewController: UIViewController, title: String, image: UIImage?, selectedImage: UIImage? = nil) {
            self.viewController = viewController
            self.title = title
            self.image = image
            self.selectedImage = selectedImage ?? image
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultAppearance()
    }
    
    /// 快速配置 TabBar
    /// - Parameters:
    ///   - tabs: 标签页配置数组
    ///   - tintColor: 选中颜色
    ///   - backgroundColor: 背景颜色
    public func configure(tabs: [TabItemConfig], tintColor: UIColor = .systemBlue, backgroundColor: UIColor = .systemBackground) {
        var controllers: [UIViewController] = []
        
        for tab in tabs {
            let vc = tab.viewController
            vc.tabBarItem = UITabBarItem(
                title: tab.title,
                image: tab.image,
                selectedImage: tab.selectedImage
            )
            controllers.append(vc)
        }
        
        self.viewControllers = controllers
        self.tintColor = tintColor
        self.tabBarBackgroundColor = backgroundColor
        
        // 强制刷新外观
        self.customTabBar.tintColor = tintColor
        self.customTabBar.backgroundColor = backgroundColor
    }
    
    private func setupDefaultAppearance() {
        // 设置原生 TabBar 样式作为底层支撑
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
