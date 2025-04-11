//
//  BlurredButton.swift
//  FlyerCard
//
//  Created by Tom.Liu on 2024/3/21.
//

import UIKit

public class TweMojiButton: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        imageView?.contentMode = .scaleAspectFit
    }
}