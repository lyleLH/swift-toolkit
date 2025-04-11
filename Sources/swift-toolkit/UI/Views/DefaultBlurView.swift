//
//  DefaultBlurView.swift
//  FashionCamera
//
//  Created by Tom.Liu on 2023/9/18.
//  Copyright © 2023 KedanLi. All rights reserved.
//

import UIKit
import VisualEffectView

 class DefaultBlurView: UIView {

    let blurEffectView: VisualEffectView = VisualEffectView(frame: .zero)
    var blurRadius: CGFloat = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInit()
    }
    
    func didInit() {
        addSubview(blurEffectView)
        backgroundColor = .clear
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            usingDarkEffect()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = bounds
        blurEffectView.blurRadius = blurRadius

    }
    
     @MainActor  func usingDarkEffect() {
        blurEffectView.colorTint = .dark
        blurEffectView.colorTintAlpha = 0.5
        blurEffectView.blurRadius = blurRadius
        blurEffectView.scale = 1
    }
    
     @MainActor func usingWhiteEffect() {
        blurEffectView.colorTint = .white
        blurEffectView.colorTintAlpha = 0.25
        blurEffectView.blurRadius = blurRadius
        blurEffectView.scale = 1
    }
    
}
