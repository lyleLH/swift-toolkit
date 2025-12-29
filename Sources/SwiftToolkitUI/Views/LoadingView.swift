//
//  LoadingView.swift
//  Recipes
//
//  Created by Ivan Semenov on 10.07.2023.
//

import UIKit

open class LoadingView: UIActivityIndicatorView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        color = .appWhite
        hidesWhenStopped = true
    }
    
}
