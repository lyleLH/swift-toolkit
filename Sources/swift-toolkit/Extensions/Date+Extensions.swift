import Foundation

public extension Date {
    /// 获取日期的年份
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    /// 获取日期的月份
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    /// 获取日期的日
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    /// 将日期格式化为字符串
    /// - Parameter format: 日期格式
    /// - Returns: 格式化后的字符串
    func formattedString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// 判断日期是否是今天
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// 判断日期是否是昨天
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    /// 获取日期的开始时间（00:00:00）
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// 获取日期的结束时间（23:59:59）
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
} 