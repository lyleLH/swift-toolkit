//
//  UIButton + Done.swift
//  FlyerCard
//
//  Created by hao92 on 2024-12-16.
//

import UIKit
import TwemojiKit



public extension UIButton {
    @MainActor
    static func makeTwEmojiButton(emoji: String, size: CGSize? = CGSize(width: 24, height: 24), forThumbnail: Bool = false) -> UIButton {
        let button = TweMojiButton(type: .custom)
        Task {
           do {
               let image = try await UIImage.loadTwEmoji(emoji: emoji, size: size ?? CGSize(width: 24, height: 24),forThumbnail: forThumbnail)
               DispatchQueue.main.async {
                   button.setImage(image, for: .normal)
               }
           }
       }
        return button
    }
    
    @MainActor
    static func makeNavigationButton(button: UIButton) -> UIButton {
        button.translatesAutoresizingMaskIntoConstraints = false
        // 设置样式
        button.backgroundColor = .systemBackground
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        
        // 设置内边距
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }
    
    @MainActor
    static func makeConfirmationButton(title: String, emoji: String, style: ConfirmationButtonStyle) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // 根据样式设置颜色
        switch style {
        case .cancel:
            button.backgroundColor = .systemGray6
            button.setTitleColor(.systemGray, for: .normal)
        case .destructive:
            button.backgroundColor = .systemRed.withAlphaComponent(0.1)
            button.setTitleColor(.systemRed, for: .normal)
        }
        
        // 异步加载 Twemoji
        Task {
            do {
                let image = try await UIImage.loadTwEmoji(emoji: emoji, size: CGSize(width: 24, height: 24), forThumbnail: false)
                button.setImage(image, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
            } catch {
                print("Failed to load emoji for button: \(error)")
            }
        }
        
        return button
    }
    
    enum ConfirmationButtonStyle {
        case cancel
        case destructive
    }
}
