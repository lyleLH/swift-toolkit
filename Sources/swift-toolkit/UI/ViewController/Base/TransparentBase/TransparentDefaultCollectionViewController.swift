//
//  TransparentDefaultCollectionViewController.swift
//  FashionCamera
//
//  Created by Tom.Liu on 2024/9/20.
//

import UIKit

class TransparentDefaultCollectionViewController: DefaultCollectionViewController {

    override var navigationBarBackgroundColor: UIColor {
        .clear
    }
    
    override var navigationBarIsTranslucent: Bool {
        true
    }
    
    override var navigationBarTintColor: UIColor {
        .white
    }
    
    override var navigationViewBackgroundColor: UIColor {
        .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.backgroundColor = .clear
    }
}
