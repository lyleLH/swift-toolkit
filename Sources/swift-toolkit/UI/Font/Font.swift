//
//  FashionFont.swift
//  FashionCamera
//
//  Created by Kedan Li on 9/23/18.
//  Copyright © 2018 KedanLi. All rights reserved.
//

import UIKit

struct FontName {
	static let regular = "Poppins-Regular"
	static let bold = "Poppins-Bold"
	static let semiBold = "Poppins-SemiBold"
	static let medium = "Poppins-Medium"
	static let lightAlt = "Poppins-Light"
}

extension UIFontDescriptor.AttributeName {
	static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
	
    class func fontNameForStyle(style: UIFont.TextStyle) -> String {

        switch style {
        case .largeTitle:
            return FontName.bold
        case .title1:
            return FontName.semiBold
        case .title2:
            return FontName.semiBold
        case .title3:
            return FontName.semiBold
        case .headline:
            return FontName.medium
        case .subheadline:
            return FontName.regular
        case .body:
            return FontName.regular
        case .callout:
            return FontName.medium
        case .footnote:
            return FontName.regular
        case .caption1:
            return FontName.medium
        case .caption2:
            return FontName.regular
        default:
            return FontName.regular
        }
    }
    
    class func sizeForStyle(style: UIFont.TextStyle) -> CGFloat {
        switch style {
        case .largeTitle:
            return 34
        case .title1:
            return 25
        case .title2:
            return 18
        case .title3:
            return 16
        case .headline:
            return 14
        case .subheadline:
            return 14
        case .body:
            return 13
        case .callout:
            return 12
        case .footnote:
            return 11
        case .caption1:
            return 10
        case .caption2:
            return 10
        default:
            return 10
        }
    }
    
    @objc class func fontWeight600(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.semiBold, size: size)!
    }
    
	@objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: FontName.regular, size: size)!
	}

	@objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: FontName.semiBold, size: size)!
	}

	@objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: FontName.lightAlt, size: size)!
	}
	
	@objc class func myPreferedFont(textStyle: TextStyle) -> UIFont {
		return UIFont(name: fontNameForStyle(style: textStyle), size: sizeForStyle(style: textStyle))!
	}

	@objc convenience init(myCoder aDecoder: NSCoder) {
		guard let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
			let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
			self.init(myCoder: aDecoder)
			return
		}
		var fontName = ""
		switch fontAttribute {
		case "CTFontRegularUsage":
			fontName = FontName.regular
		case "CTFontEmphasizedUsage":
			fontName = FontName.medium
		case "CTFontBoldUsage":
			fontName = FontName.semiBold
		case "CTFontObliqueUsage":
			fontName = FontName.lightAlt
		default:
			fontName = FontName.regular
		}
		self.init(name: fontName, size: fontDescriptor.pointSize)!
	}

	class func overrideInitialize() {
		guard self == UIFont.self else { return }

		if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
			let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
			method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
		}

		if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
			let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
			method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
		}

		if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
			let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
			method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
		}
		
		if let initCoderMethod = class_getClassMethod(self, #selector(preferredFont(forTextStyle:))),
			let myInitCoderMethod = class_getClassMethod(self, #selector(myPreferedFont(textStyle:))) {
			method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
		}
		
		if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
			let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
			method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
		}
	}
    
    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

extension UILabel {
	override open func awakeFromNib() {
		super.awakeFromNib()
		Task { @MainActor in
			configureLabel()
		}
	}
	
	override open func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		Task { @MainActor in
			configureLabel()
		}
	}

	@MainActor
	func configureLabel() {
		if let font = font {
			if let fontStyle: UIFont.TextStyle = font.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle {
				self.font = UIFont.preferredFont(forTextStyle: fontStyle)
			}
		}
	}
}

extension UITextField {
	override open func awakeFromNib() {
		super.awakeFromNib()
		Task { @MainActor in
			configureLabel()
		}
	}
	
	override open func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		Task { @MainActor in
			configureLabel()
		}
	}

	@MainActor
	func configureLabel() {
		if let font = font {
			if let fontStyle: UIFont.TextStyle = font.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle {
				self.font = UIFont.preferredFont(forTextStyle: fontStyle)
			}
		}
	}
}

extension UITextView {
	override open func awakeFromNib() {
		super.awakeFromNib()
		Task { @MainActor in
			configureLabel()
		}
	}
	
	override open func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		Task { @MainActor in
			configureLabel()
		}
	}

	@MainActor
	func configureLabel() {
		if let font = font {
			if let fontStyle: UIFont.TextStyle = font.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle {
				self.font = UIFont.preferredFont(forTextStyle: fontStyle)
			}
		}
	}
}

extension UIButton {
	override open func awakeFromNib() {
		super.awakeFromNib()
		Task { @MainActor in
			configureLabel()
		}
	}
	
	override open func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		Task { @MainActor in
			configureLabel()
		}
	}

	@MainActor
	func configureLabel() {
		if let titleLabel = self.titleLabel,
		   let font = titleLabel.font,
		   let fontStyle: UIFont.TextStyle = font.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle {
			titleLabel.font = UIFont.preferredFont(forTextStyle: fontStyle)
		}
	}
}
