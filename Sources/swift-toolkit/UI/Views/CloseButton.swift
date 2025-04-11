//
//  CloseButton.swift
//  FashionCamera
//
//  Created by Li Kedan on 6/27/22.
//  Copyright © 2022 KedanLi. All rights reserved.
//

import UIKit

public class CloseButton: DefaultButton {
	
	override func commonInit() {
		super.commonInit()
        // swiftlint:disable line_length
        setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: UIImage.SymbolWeight.medium, scale: .medium))?.withTintColor(UIColor.lightGrey), for: .normal)
        // swiftlint:enable line_length
	}
    
    func updateIconColor(color: UIColor) {
        // swiftlint:disable line_length
        setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: UIImage.SymbolWeight.medium, scale: .medium))?.withTintColor(color), for: .normal)
        // swiftlint:enable line_length
        
    }

}
