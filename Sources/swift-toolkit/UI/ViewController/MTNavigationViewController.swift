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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        naviBarSetting()

    }
 
    private func naviBarSetting() {
        
        for controlState in [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.disabled] {
            // swiftlint:disable line_length
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline) as Any], for: controlState)
            // swiftlint:enable line_length
        }
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = bgColor
        navigationBar.isTranslucent = isTranslucent
        navigationBar.backItem?.backButtonDisplayMode = .minimal
        //        navigationBar.tintColor = UIColor.dark
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: 
                                                UIFont.preferredFont(forTextStyle: .headline) as Any]
        
    }
}
