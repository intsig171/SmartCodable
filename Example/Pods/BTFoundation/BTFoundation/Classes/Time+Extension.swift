//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//


import Foundation
import BTNameSpace

public enum BTDateFormatterType: String {
    /// yyyy （年，例如：2021）
    case yyyy = "yyyy"
    /// MM (月，例如： 03月)
    case MM = "MM"
    /// dd （天，例如：20）
    case dd = "dd"
    /// yyyy-MM （年-月，例如：2021-02）
    case yyMM = "yyyy-MM"
    /// yyyy-MM-dd（年-月-日，例如：2021-02-01）
    case yyyyMMdd = "yyyy-MM-dd"
    /// yyyy-MM-dd HH:mm （年-月-日 时：分）
    case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
    /// yyyy-MM-dd HH:mm:ss（年-月-日 时：分：秒）
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    /// MM-dd HH:mm:ss（月-日 时：分：秒）
    case MMddHHmmss = "MM-dd HH:mm:ss"
}


//  指定格式化方式，只创建一次，效率高
private let dateFormatter = DateFormatter()
extension Date : NamespaceWrappable { }

extension NamespaceWrapper where T == String {
    /// 时间字符串转时间字符串
    /// - Parameters:
    ///   - before: 格式化之前的时间格式
    ///   - after: 格式化之后的时间格式
    /// - Returns: 格式化的时间字符串
    public func toFormatDateString(before: BTDateFormatterType, after: BTDateFormatterType) -> String? {
                
        dateFormatter.dateFormat = before.rawValue
        
        if let date = dateFormatter.date(from: wrappedValue) {
            dateFormatter.dateFormat = after.rawValue
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    /// 字符串转Date
    public func toDate(_ formatType: BTDateFormatterType) -> Date? {
        
        dateFormatter.dateFormat = formatType.rawValue
        let date = dateFormatter.date(from: wrappedValue)
        return date
    }
    
    /// 时间字符串转时间戳
    public func toTimeStamp(_ formatType: BTDateFormatterType) -> TimeInterval {
        
        dateFormatter.dateFormat = formatType.rawValue
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from: wrappedValue)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        return dateStamp
    }
    
    /// 时间字符串转智能显示时间
    public func toWisdomTime(_ formatType: BTDateFormatterType) -> String {
        dateFormatter.dateFormat = formatType.rawValue
        if let date = dateFormatter.date(from: wrappedValue) {
            return date.toWisdomTime()
        } else {
            return "-"
        }
    }
}

extension NamespaceWrapper where T == TimeInterval {
    /// 时间戳转时间字符串
    public func toTimeStr(_ formatType: BTDateFormatterType) -> String {
        let date = Date.init(timeIntervalSince1970: wrappedValue)
        dateFormatter.dateFormat = formatType.rawValue
        return dateFormatter.string(from: date)
    }
    
    /// 时间戳转Date
    public func toDate() -> Date {
        return Date.init(timeIntervalSince1970: wrappedValue)
    }
    
    /// 时间戳转智能时间
    public func toWisdomTime() -> String {
        let date = Date.init(timeIntervalSince1970: wrappedValue)
        return date.toWisdomTime()
    }
}


extension NamespaceWrapper where T == Date {
    ///Date转字符串
    public func toTimeStr(_ formatType: BTDateFormatterType) -> String {
        
        dateFormatter.dateFormat = formatType.rawValue
        let str = dateFormatter.string(from: wrappedValue)
        return str
    }
    
    ///Date转时间戳(距离1970年的时间间隔)
    public func toTimeInterval() -> TimeInterval {
        let dateStamp:TimeInterval = wrappedValue.timeIntervalSince1970
        return dateStamp
    }
    
    /// 转为DateComponents对象
    public func getDateComponents() -> DateComponents {
        let calendar = Calendar.current
        let unit:Set<Calendar.Component> = [.year,.month,.day,.hour,.minute,.second]
        let components = calendar.dateComponents(unit, from: wrappedValue)
        return components
    }
    
    
    /// 世界时间转为本地时间
    public func toLocalDate() -> Date {
        let localTimeZone = TimeZone.current
        let offset = localTimeZone.secondsFromGMT(for: wrappedValue)
        let localDate = wrappedValue.addingTimeInterval(Double(offset))
        return localDate
    }
    


    /// 比较两个时间大小（是否大于等于）
    /// - Parameter date: 被比较的时间
    /// - Returns: 是否大于等于
    public func compareDate(_ date: Date) -> Bool {

        let status =  wrappedValue.compare(date)

        switch status {
        case .orderedAscending:
            return false
        case .orderedSame:
            return true
        case .orderedDescending:
            return true
        }
    }


    /// 获取两个时间点之间的天数
    /// - Parameter to: 截止时间
    /// - Returns: 天数
    public func differenceOfDays(to: Date) -> Int? {
        let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let comp = calendar.dateComponents([.day], from: wrappedValue, to: to)
        return comp.day
    }
    
    
    /// 当前时间戳 (秒)
    public static var currentTimeStamp: Double {
        let date = Date.init(timeIntervalSinceNow: 0)
        let interval = date.timeIntervalSince1970
        return interval
    }
}




extension Date {
    /// 支付串转智能显示时间
    fileprivate func toWisdomTime() -> String {

        ///  根据指定时间对象判断是否是今年
        func isThisYear(createAtDate: Date) -> Bool {

            //  指定格式化方式
            dateFormatter.dateFormat = "yyyy"
            //  获取时间的年份
            let createAtYear = dateFormatter.string(from: createAtDate)
            //  获取当前时间的年份
            let currentDateYear = dateFormatter.string(from: Date())
            //  判断时间年份是否相同
            return createAtYear == currentDateYear
        }

        //是今年
        if isThisYear(createAtDate: self) {
            //  日历对象
            let currentCalendar = Calendar.current
            if currentCalendar.isDateInToday(self) {
                
                let timeinterVal: TimeInterval = abs(self.timeIntervalSinceNow)
                if timeinterVal < 60 {
                    return "刚刚"
                } else if timeinterVal < 3600 {
                    let result = timeinterVal / 60
                    return "\(Int(result))分钟前"
                } else {
                    let result = timeinterVal / 3600
                    return "\(Int(result))小时前"
                }
            } else if currentCalendar.isDateInYesterday(self) { //  表示昨天
                dateFormatter.dateFormat = "昨天 HH:mm"
            } else { //  其它
                dateFormatter.dateFormat = "MM-dd HH:mm"
            }
        } else { //  不是今年
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        
        return dateFormatter.string(from: self)
    }
}





