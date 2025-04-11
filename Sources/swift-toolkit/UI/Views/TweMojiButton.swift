//
//  BlurredButton.swift
//  FlyerCard
//
//  Created by Tom.Liu on 2024/3/21.
//

import UIKit

class TweMojiButton: DefaultButton {
    
    private let blurView = DefaultBlurView(frame: .zero)
    
    var blurRadius: CGFloat {
        get { blurView.blurRadius }
        set { blurView.blurRadius = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBlurView()
    }
    
    private func setupBlurView() {
        // 将模糊视图插入到按钮的背景视图层
 
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 让模糊视图填充整个按钮的背景区域
        if let backgroundView = subviews.first {
            blurView.frame = backgroundView.bounds
        } else {
            blurView.frame = bounds
        }
    }
    
    // 便利方法设置暗色或亮色模糊效果
    @MainActor
    func useDarkEffect() {
        blurView.usingDarkEffect()
    }
    
    @MainActor
    func useWhiteEffect() {
        blurView.usingWhiteEffect()
    }
} 
