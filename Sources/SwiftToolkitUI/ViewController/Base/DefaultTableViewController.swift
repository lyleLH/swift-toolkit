//
//  DefaultTableViewController.swift
//  FirebaseLogin
//
//  Created by Tom.Liu on 2024/9/20.
//

import UIKit

open class DefaultTableViewController: UITableViewController {

    open var navigationBarHidden: Bool {
        return false
    }
    
    open var navigationBarIsTranslucent: Bool {
        return false
    }
    
    open var navigationBarBackgroundColor: UIColor {
        return .white
    }
    
    open var navigationBarTintColor: UIColor {
        return .black
    }
    
    open var navigationViewBackgroundColor: UIColor {
        return .white
    }
    
    open var defaultNavigationController: DefaultNavigationViewController? {
        return navigationController as? DefaultNavigationViewController
    }
    
    private lazy var transitionbBlurView: DefaultBlurView = {
        let transitionbBlurView = DefaultBlurView(frame: .zero)
        transitionbBlurView.usingDarkEffect()
        return transitionbBlurView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftItemsSupplementBackButton = true

        // Do any additional setup after loading the view.
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if let parent: DefaultViewController = parent as? DefaultViewController {
            navigationController?.navigationBar.isHidden = parent.navigationBarHidden
            navigationController?.navigationBar.isTranslucent = parent.navigationBarIsTranslucent
            navigationController?.navigationBar.backgroundColor = parent.navigationBarBackgroundColor
            navigationController?.navigationBar.tintColor = parent.navigationBarTintColor
            navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = parent.navigationBarTintColor
            navigationController?.view.backgroundColor = parent.navigationViewBackgroundColor
        } else if let parent: DefaultTableViewController = parent as? DefaultTableViewController {
            navigationController?.navigationBar.isHidden = parent.navigationBarHidden
            navigationController?.navigationBar.isTranslucent = parent.navigationBarIsTranslucent
            navigationController?.navigationBar.backgroundColor = parent.navigationBarBackgroundColor
            navigationController?.navigationBar.tintColor = parent.navigationBarTintColor
            navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = parent.navigationBarTintColor
            navigationController?.view.backgroundColor = parent.navigationViewBackgroundColor
        } else if let parent: DefaultCollectionViewController = parent as? DefaultCollectionViewController {
            navigationController?.navigationBar.isHidden = parent.navigationBarHidden
            navigationController?.navigationBar.isTranslucent = parent.navigationBarIsTranslucent
            navigationController?.navigationBar.backgroundColor = parent.navigationBarBackgroundColor
            navigationController?.navigationBar.tintColor = parent.navigationBarTintColor
            navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = parent.navigationBarTintColor
            navigationController?.view.backgroundColor = parent.navigationViewBackgroundColor
        } else {
            navigationController?.navigationBar.isHidden = navigationBarHidden
            navigationController?.navigationBar.isTranslucent = navigationBarIsTranslucent
            navigationController?.navigationBar.backgroundColor = navigationBarBackgroundColor
            navigationController?.navigationBar.tintColor = navigationBarTintColor
            navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = navigationBarTintColor
            navigationController?.view.backgroundColor = navigationViewBackgroundColor
        }
        
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
