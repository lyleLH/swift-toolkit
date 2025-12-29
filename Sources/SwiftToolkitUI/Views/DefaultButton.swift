//
//  Button.swift
//  FashionCamera
//
//  Created by Li Kedan on 10/10/20.
//  Copyright © 2020 KedanLi. All rights reserved.
//

import UIKit

open class DefaultButton: UIButton {
	
	open func commonInit() {
		// to be override by subclas
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

}
