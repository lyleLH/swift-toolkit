//
//  DefaultViewController.swift
//  FirebaseLogin
//
//  Created by Tom.Liu on 2024/9/20.
//

import UIKit
import ProgressHUD

open class DefaultViewController: UIViewController {

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
    
    open var isBackButtonHasBackground: Bool {
        return false
    }

    open var defaultNavigationController: DefaultNavigationViewController? {
        return navigationController as? DefaultNavigationViewController
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.leftItemsSupplementBackButton = true

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
        super.viewDidAppear(animated)
        
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
   
    }
 
}

public extension UIViewController {
    
    func parentOrNavVC() -> UIViewController? {
        return self.navigationController ?? self.parent
    }
    
    func rootVC() -> UIViewController {
        var currentVC = self
        
        while let parent = currentVC.parentOrNavVC() {
            currentVC = parent
        }
        return currentVC
    }
    
    func showHud(labelText: String) {
        ProgressHUD.banner("", labelText, delay: 0.0)
    }
    
    func showSuccessHud(labelText: String, delay: Double = 2) {
        ProgressHUD.succeed(labelText, delay: delay)
    }

}

extension UIViewController: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    public func presentationController(_ presentationController: UIPresentationController, prepare adaptivePresentationController: UIPresentationController) {
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        setNeedsStatusBarAppearanceUpdate()
    }
    
}
 
