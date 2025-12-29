//
//  DefaultCollectionViewController.swift
//  FirebaseLogin
//
//  Created by Tom.Liu on 2024/9/20.
//

import UIKit

open class DefaultCollectionViewController: UICollectionViewController {

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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftItemsSupplementBackButton = true

        // Do any additional setup after loading the view.
    }
    
    open var defaultNavigationController: DefaultNavigationViewController? {
        return navigationController as? DefaultNavigationViewController
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
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public func safeReload(indexPath: IndexPath) {
        self.collectionView.reloadData()
//  TODO: still occasionally crash when performing specific reload
//        if self.collectionView.cellForItem(at: indexPath) != nil {
//            self.collectionView.reloadItems(at: [indexPath])
//        } else {
//            self.collectionView.reloadData()
//        }
    }
}
