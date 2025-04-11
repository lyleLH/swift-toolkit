//
//  UIImage+EdgeInset.swift
//  FashionCamera
//
//  Created by Li Kedan on 6/16/22.
//  Copyright © 2022 KedanLi. All rights reserved.
//

import UIKit

public extension UIImage {
	func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(
			CGSize(width: size.width + insets.left + insets.right,
				   height: size.height + insets.top + insets.bottom),
			false,
			self.scale)

		let origin = CGPoint(x: insets.left, y: insets.top)
		self.draw(at: origin)
		let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return imageWithInsets
	}
}

public extension UIImage {

    func addWaterMark(watermarkImage: UIImage = #imageLiteral(resourceName: "Stylespacelogo.png"), watermarkSize: CGSize = CGSize(width: 50, height: 50)) -> UIImage? {
        let backgroundImage = self
        let watermarkImage = watermarkImage

        let size = backgroundImage.size
        let scale = backgroundImage.scale

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        backgroundImage.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        watermarkImage.draw(in: CGRect(x: 0, y: size.height - watermarkSize.height, width: watermarkSize.width, height: watermarkSize.height))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    static func downloadImage(urlString: String) async throws -> UIImage {

        // Attempt to download the image first.
        let imageUrl = URL(string: urlString)!
        let imageRequest = URLRequest(url: imageUrl)
        let (imageData, imageResponse) = try await URLSession.shared.data(for: imageRequest)
        guard let image = UIImage(data: imageData), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw LocalError(title: "download image failed")
        }
        return image
    }
    
    static func compositeTwoImages(top: UIImage, bottom: UIImage, newSize: CGSize) -> UIImage? {
        // begin context with new size
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        // draw images to context
        bottom.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        top.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        // return the new image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // returns an optional
        return newImage
    }
    
    static func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func rotate(radian: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: radian)
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        
        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)
        bitmap.draw(cgImage!, in: CGRect(origin: origin, size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func fixRotationIfNecessaryImage() -> UIImage?  {
        if (self.imageOrientation == UIImage.Orientation.up ) {
            return self
        }
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
       let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
    
    func resize(to squareWidth: CGFloat) -> UIImage {
        // calculate scaling ratio
        let imageWidth = self.size.width
        let ratio = Double(squareWidth) / Double(imageWidth)
        
        // resize image
        let size = self.size.applying(CGAffineTransform(scaleX: CGFloat(ratio), y: CGFloat(ratio)))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return (scaledImage == nil) ? self : scaledImage!
    }
    
    func cropImageToSquare() -> UIImage? {
        let image = self
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        return nil
    }
    
    func crop(rect: CGRect) -> UIImage? {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformedCropRect = rect.applying(transform)
        
        if let imageRef = cgImage?.cropping(to: transformedCropRect) {
            let croppedImage = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
            return croppedImage
        }
        return nil
    }
    
//    func crop(rect: CGRect) -> UIImage? {
//
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//
//        let drawRect = CGRect(x: -rect.origin.x, y: -rect.origin.y, width: size.width, height: size.height)
//        context?.clip(to: CGRect(x: 0, y: 0,width: rect.size.width, height: rect.size.height))
//
//        draw(in: drawRect)
//
//        let subImage = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//        return subImage
//    }

    
    func overlapWithImage(topImage: UIImage, at coordinate: CGPoint) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        topImage.draw(in: CGRect(origin: coordinate, size: topImage.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func from(color: UIColor, of size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    // Convert CIImage to CGImage
    static func from(cimage: CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cimage, from: cimage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    class func drawCircle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    func squareWithColorPadding(color: UIColor) -> UIImage {
        
        var squareImage = self
        let maxSize = max(self.size.height, self.size.width)
        let squareSize = CGSize(width: maxSize, height: maxSize)
        
        let dx = CGFloat((maxSize - self.size.width) / 2)
        let dy = CGFloat((maxSize - self.size.height) / 2)
        
        UIGraphicsBeginImageContextWithOptions(squareSize, false, 1)
        var rect = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            rect = rect.insetBy(dx: dx, dy: dy)
            self.draw(in: rect, blendMode: .normal, alpha: 1.0)
            
            if let img = UIGraphicsGetImageFromCurrentImageContext() {
                squareImage = img
            }
            UIGraphicsEndImageContext()
            
        }
        
        return squareImage
    }
    
}
