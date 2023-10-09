//
//  DefaultValuePatcher.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/22.
//

import Foundation


/// 默认值兼容器
struct DefaultValuePatcher<T: Decodable> {
    
    /// 生产对应类型的默认值
    static func makeDefaultValue() throws -> T? {

        if let arr = [] as? T {
            return arr
            
        } else if let dict = [:] as? T {
            return dict
            
        } else if let value = "" as? T {
            return value
        } else if let value = false as? T {
            return value
        } else if let value = Date.defaultValue as? T {
            return value
        } else if let value = Data.defaultValue as? T {
            return value
        } else if let value = Decimal.defaultValue as? T {
            return value
                        
        } else if let value = Double(0.0) as? T {
            return value
        } else if let value = Float(0.0) as? T {
            return value
        } else if let value = CGFloat(0.0) as? T {
            return value
            
        } else if let value = Int(0) as? T {
            return value
        } else if let value = Int8(0) as? T {
            return value
        } else if let value = Int16(0) as? T {
            return value
        } else if let value = Int32(0) as? T {
            return value
        } else if let value = Int64(0) as? T {
            return value
                        
        } else if let value = UInt(0) as? T {
            return value
        } else if let value = UInt8(0) as? T {
            return value
        } else if let value = UInt16(0) as? T {
            return value
        } else if let value = UInt32(0) as? T {
            return value
        } else if let value = UInt64(0) as? T {
            return value
        } else {
            /// 判断此时的类型是否实现了SmartCodable， 如果是就说明是自定义的结构体或类。
            if let object = T.self as? SmartDecodable.Type {
                return object.init() as? T
            } else {
                SmartLog.logDebug("\(Self.self)提供默认值失败, 发现未知类型，无法提供默热值。如有遇到请反馈，感谢")
                return nil
            }
        }
    }
}






fileprivate protocol Defaultable {
    static var defaultValue: Self { get }
}


extension Date: Defaultable {
    fileprivate static var defaultValue: Date {
        return Date(timeIntervalSinceReferenceDate: 0)
    }
    
    fileprivate static func defaultValue(for strategy: JSONDecoder.DateDecodingStrategy) -> Date {
        switch strategy {
        case .secondsSince1970, .millisecondsSince1970:
            return Date(timeIntervalSince1970: 0)
        default:
            return defaultValue
        }
    }
}

extension Data: Defaultable {
    fileprivate static var defaultValue: Data {
        return Data()
    }
}

extension Decimal: Defaultable {
    fileprivate static var defaultValue: Decimal {
        return Decimal(0)
    }
}
