//
//  Button.swift
//  FashionCamera
//
//  Created by Li Kedan on 10/10/20.
//  Copyright © 2020 KedanLi. All rights reserved.
//

import UIKit

class DefaultButton: UIButton {
	
	func commonInit() {
		// to be override by subclas
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

}
