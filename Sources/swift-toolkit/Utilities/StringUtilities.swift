import Foundation
#if canImport(CommonCrypto)
import CommonCrypto
#endif

public extension String {
    /// 检查字符串是否是有效的电子邮件地址
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// 检查字符串是否是有效的手机号码（中国）
    var isValidChinesePhoneNumber: Bool {
        let phoneRegex = "^1[3-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    /// 将字符串转换为拼音
    var pinyin: String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return String(mutableString)
    }
    
    #if canImport(CommonCrypto)
    /// 获取字符串的MD5值
    var md5: String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_MD5(buffer.baseAddress, CC_LONG(buffer.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    #else
    /// 获取字符串的MD5值（仅在支持CommonCrypto的平台可用）
    var md5: String {
        fatalError("MD5 is not supported on this platform")
    }
    #endif
} 