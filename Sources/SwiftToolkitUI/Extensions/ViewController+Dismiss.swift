//
//  ViewController+Dismiss.swift
//  FashionCamera
//
//  Created by Li Kedan on 6/17/22.
//  Copyright © 2022 KedanLi. All rights reserved.
//

import UIKit

public extension UIViewController {

	@IBAction func closeClicked(_ sender: Any) {
		smartDismiss()
	}
    
    func addCloseItem(closeFunction: Selector = #selector(closeClicked), force: Bool = false, hasBackground: Bool = false) {
        let adjsutView = UIView(frame: CGRect(x: 0, y: 0, width: 67, height: 44))
        adjsutView.backgroundColor = .clear
        
        let closeButton = CloseButton(frame: CGRect(x: 0, y: 6, width: 32, height: 32))
        adjsutView.addSubview(closeButton)
        closeButton.addTarget(self, action: closeFunction, for: .touchUpInside)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: adjsutView)]

		if !force, navigationController?.viewControllers[0] != self {
			navigationItem.leftBarButtonItems?.removeAll()
		}
	}
    
    @MainActor
    func smartDismiss(_ animate: Bool = true, completion: (() -> Void)? = nil) {
        if navigationController == nil {
            dismiss(animated: animate, completion: completion)
        } else {
            var currentVC: UIViewController? = self
            while currentVC != nil {
                // if this is the children of the first VC, than dismiss
                if navigationController?.viewControllers[0] == currentVC {
                    dismiss(animated: animate, completion: completion)
                    break
                }
                currentVC = currentVC?.parent
            }
            _ = navigationController?.popViewController(animated: animate)
            completion?()
        }
    }
}
