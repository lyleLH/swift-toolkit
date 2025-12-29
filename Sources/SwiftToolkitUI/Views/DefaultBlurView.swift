//
//  DefaultBlurView.swift
//  FashionCamera
//
//  Created by Tom.Liu on 2023/9/18.
//  Copyright © 2023 KedanLi. All rights reserved.
//

import UIKit
import VisualEffectView

open class DefaultBlurView: UIView {

    public let blurEffectView: VisualEffectView = VisualEffectView(frame: .zero)
    public var blurRadius: CGFloat = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInit()
    }
    
    public func didInit() {
        addSubview(blurEffectView)
        backgroundColor = .clear
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            usingDarkEffect()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = bounds
        blurEffectView.blurRadius = blurRadius
    }
    
    @MainActor public func usingDarkEffect() {
        blurEffectView.colorTint = .dark
        blurEffectView.colorTintAlpha = 0.5
        blurEffectView.blurRadius = blurRadius
        blurEffectView.scale = 1
    }
    
    @MainActor public func usingWhiteEffect() {
        blurEffectView.colorTint = .white
        blurEffectView.colorTintAlpha = 0.25
        blurEffectView.blurRadius = blurRadius
        blurEffectView.scale = 1
    }
}
