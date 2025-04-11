//
//  WhiteBlurView.swift
//  FashionCamera
//
//  Created by Tom.Liu on 2023/10/19.
//  Copyright © 2023 KedanLi. All rights reserved.
//

import UIKit
import VisualEffectView

public class WhiteBlurView: UIView {

    var blurEffectView: VisualEffectView = VisualEffectView(frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInit()
        backgroundColor = .clear
    }
    
    func didInit() {
        addSubview(blurEffectView)
        blurEffectView.blurRadius = 10
        blurEffectView.scale = 1
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = bounds
    }

}
