//
//  WhiteBlurView.swift
//  FashionCamera
//
//  Created by Tom.Liu on 2023/10/19.
//  Copyright © 2023 KedanLi. All rights reserved.
//

import UIKit
import VisualEffectView

open class WhiteBlurView: UIView {

    public var blurEffectView: VisualEffectView = VisualEffectView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInit()
        backgroundColor = .clear
    }
    
    public func didInit() {
        addSubview(blurEffectView)
        blurEffectView.blurRadius = 10
        blurEffectView.scale = 1
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = bounds
    }
}
