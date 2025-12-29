import UIKit
import SwiftToolkit
import SwiftToolkitUI

class TabBarDemoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "TabBar Demo"
        
        let btn = UIButton(configuration: .filled())
        btn.setTitle("Open TabBar Controller", for: .normal)
        btn.addTarget(self, action: #selector(openTabBar), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btn.heightAnchor.constraint(equalToConstant: 50),
            btn.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        let label = UILabel()
        label.text = "Click to present a full-screen custom TabBarController"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: btn.topAnchor, constant: -20)
        ])
    }
    
    @objc func openTabBar() {
        let tabBar = MTTabBarController()
        
        // 1. Home VC
        let homeVC = UIViewController()
        homeVC.view.backgroundColor = .systemGroupedBackground
        homeVC.title = "Home"
        let homeNav = DefaultNavigationViewController(rootViewController: homeVC)
        
        // Add close button
        homeVC.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { [weak tabBar] _ in
            tabBar?.dismiss(animated: true)
        })
        
        // Add content
        let label = UILabel()
        label.text = "Home Tab"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        homeVC.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: homeVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: homeVC.view.centerYAnchor)
        ])
        
        // 2. Settings VC
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .systemGroupedBackground
        settingsVC.title = "Settings"
        let settingsNav = DefaultNavigationViewController(rootViewController: settingsVC)
        
        let label2 = UILabel()
        label2.text = "Settings Tab"
        label2.font = .preferredFont(forTextStyle: .largeTitle)
        label2.translatesAutoresizingMaskIntoConstraints = false
        settingsVC.view.addSubview(label2)
        NSLayoutConstraint.activate([
            label2.centerXAnchor.constraint(equalTo: settingsVC.view.centerXAnchor),
            label2.centerYAnchor.constraint(equalTo: settingsVC.view.centerYAnchor)
        ])
        
        // Configure Tabs
        let config = [
            MTTabBarController.TabItemConfig(
                viewController: homeNav,
                title: "Home",
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            ),
            MTTabBarController.TabItemConfig(
                viewController: settingsNav,
                title: "Settings",
                image: UIImage(systemName: "gearshape"),
                selectedImage: UIImage(systemName: "gearshape.fill")
            )
        ]
        
        tabBar.configure(tabs: config, tintColor: .systemBlue)
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
}
