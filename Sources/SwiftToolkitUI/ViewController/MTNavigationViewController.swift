//
//  MTNavigationViewController.swift
//  FirebaseLogin
//
//  Created by Tom.Liu on 2024/6/24.
//

import UIKit

public class MTNavigationViewController: UINavigationController {

    var bgColor: UIColor = .white
    var isTranslucent = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        // 设置导航栏外观
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
        
        // 设置返回按钮颜色
        navigationBar.tintColor = .label
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 设置返回按钮标题
        if viewControllers.count > 0 {
            viewController.navigationItem.backButtonTitle = ""
        }
        super.pushViewController(viewController, animated: animated)
    }
}
