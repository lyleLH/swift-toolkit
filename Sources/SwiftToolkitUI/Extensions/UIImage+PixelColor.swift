import UIKit

public extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor? {
        guard let cgImage = cgImage else { return nil }
        
        let width = Int(size.width)
        let height = Int(size.height)
        let x = min(max(0, Int(pos.x)), width - 1)
        let y = min(max(0, Int(pos.y)), height - 1)
        
        guard let provider = cgImage.dataProvider,
              let providerData = provider.data,
              let data = CFDataGetBytePtr(providerData) else {
            return nil
        }
        
        let numberOfComponents = 4
        let pixelData = ((width * y) + x) * numberOfComponents
        
        let r = CGFloat(data[pixelData]) / 255.0
        let g = CGFloat(data[pixelData + 1]) / 255.0
        let b = CGFloat(data[pixelData + 2]) / 255.0
        let a = CGFloat(data[pixelData + 3]) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
} 