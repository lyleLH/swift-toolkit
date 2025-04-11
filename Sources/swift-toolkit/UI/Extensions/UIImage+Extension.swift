import UIKit

public extension UIImage {
//    func getPixelColor(pos: CGPoint) -> UIColor? {
//        guard let cgImage = cgImage,
//              let dataProvider = cgImage.dataProvider,
//              let data = dataProvider.data,
//              let layout = cgImage.bitmapInfo.componentLayout else {
//            return .white
//        }
//        
//        let pixelData: UnsafePointer<UInt8> = CFDataGetBytePtr(data)
//        let remaining = 8 - ((Int(size.width * scale)) % 8)
//        let padding = (remaining < 8) ? remaining : 0
//        
//        var valuePerPix: Int
//        switch layout {
//        case .bgr, .rgb:
//            valuePerPix = 3
//        default:
//            valuePerPix = 4
//        }
//        
//        let pixelInfo: Int = (((Int(size.width * scale) + padding) * Int(pos.y * scale)) + Int(pos.x * scale)) * valuePerPix
//        
//        let v0 = CGFloat(pixelData[pixelInfo]) / CGFloat(255.0)
//        let v1 = CGFloat(pixelData[pixelInfo+1]) / CGFloat(255.0)
//        let v2 = CGFloat(pixelData[pixelInfo+2]) / CGFloat(255.0)
//        let v3 = CGFloat(pixelData[pixelInfo+3]) / CGFloat(255.0)
//        
//        switch layout {
//        case .bgra:
//            return UIColor(red: v2, green: v1, blue: v0, alpha: v3)
//        case .abgr:
//            return UIColor(red: v3, green: v2, blue: v2, alpha: v0)
//        case .argb:
//            return UIColor(red: v1, green: v2, blue: v3, alpha: v0)
//        case .rgba:
//            return UIColor(red: v0, green: v1, blue: v2, alpha: v3)
//        case .bgr:
//            return UIColor(red: v2, green: v1, blue: v0, alpha: 1)
//        case .rgb:
//            return UIColor(red: v0, green: v1, blue: v2, alpha: 1)
//        }
//    }
}

// MARK: - CGBitmapInfo Extension
public extension CGBitmapInfo {
    enum ComponentLayout {
        case bgra
        case abgr
        case argb
        case rgba
        case bgr
        case rgb
        
        var count: Int {
            switch self {
            case .bgr, .rgb: return 3
            default: return 4
            }
        }
    }
    
    var componentLayout: ComponentLayout? {
        guard let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue) else {
            return nil
        }
        let isLittleEndian = contains(.byteOrder32Little)
        
        if alphaInfo == .none {
            return isLittleEndian ? .bgr : .rgb
        }
        let alphaIsFirst = alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst
        
        if isLittleEndian {
            return alphaIsFirst ? .abgr : .bgra
        } else {
            return alphaIsFirst ? .argb : .rgba
        }
    }
    
    var chromaIsPremultipliedByAlpha: Bool {
        let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue)
        return alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast
    }
} 
