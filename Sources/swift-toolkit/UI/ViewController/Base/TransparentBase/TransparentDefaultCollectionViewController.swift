//
//  TransparentDefaultCollectionViewController.swift
//  FashionCamera
//
//  Created by Tom.Liu on 2024/9/20.
//

import UIKit

open class TransparentDefaultCollectionViewController: DefaultCollectionViewController {

    open override var navigationBarBackgroundColor: UIColor {
        .clear
    }
    
    open override var navigationBarIsTranslucent: Bool {
        true
    }
    
    open override var navigationBarTintColor: UIColor {
        .white
    }
    
    open override var navigationViewBackgroundColor: UIColor {
        .clear
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.backgroundColor = .clear
    }
}
