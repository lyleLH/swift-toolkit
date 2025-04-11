//
//  UIView+Helper.swift
//  FashionCamera
//
//  Created by Kedan Li on 6/6/18.
//  Copyright © 2018 KedanLi. All rights reserved.
//

import UIKit

extension UIView {

	@IBInspectable
	public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
		set (radius) {
			self.layer.cornerRadius = radius
			self.layer.masksToBounds = radius > 0
		}
	}

	@IBInspectable
	public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
		set (borderWidth) {
			self.layer.borderWidth = borderWidth
		}
	}

	@IBInspectable
	public var borderColor: UIColor? {
		set (color) {
			self.layer.borderColor = color?.cgColor
		}

		get {
			if let color = self.layer.borderColor {
				return UIColor(cgColor: color)
			} else {
				return nil
			}
		}
	}
}

extension UIView {
    
    var size: CGSize {
        return bounds.size
    }
	
	func isSubViewOf(view: UIView?) -> Bool {
		return superview == view || superview?.isSubViewOf(view: view) == true
	}

    func screenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            return image!
        }
        return UIImage()
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage(_ scale:Double? = nil) -> UIImage {
        return autoreleasepool {
            let format = UIGraphicsImageRendererFormat.default()
            format.scale = scale ?? UIScreen.main.scale
            let renderer = UIGraphicsImageRenderer(bounds: bounds,format:format )
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        }
        
    }
    
    func colorOfPoint(point: CGPoint) -> UIColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!)
        
        let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
    
    func colorOfPoints(points: [CGPoint]) -> [UIColor] {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        var colors: [UIColor] = []
                
        for point in points {
            context!.translateBy(x: -point.x, y: -point.y)
            
            self.layer.render(in: context!)
            
            let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
            let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
            let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
            let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
            
            let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            colors.append(color)
            
            // move the context back for the next action
            context!.translateBy(x: point.x, y: point.y)
        }
        
        return colors
    }
}
