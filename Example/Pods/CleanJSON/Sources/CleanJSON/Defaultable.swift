// 
//  Defaultable.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/12/14
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Bool: Defaultable {
    static var defaultValue: Bool {
        return false
    }
}

extension Int: Defaultable {
    static var defaultValue: Int {
        return 0
    }
}

extension Int8: Defaultable {
    static var defaultValue: Int8 {
        return 0
    }
}

extension Int16: Defaultable {
    static var defaultValue: Int16 {
        return 0
    }
}

extension Int32: Defaultable {
    static var defaultValue: Int32 {
        return 0
    }
}

extension Int64: Defaultable {
    static var defaultValue: Int64 {
        return 0
    }
}

extension UInt: Defaultable {
    static var defaultValue: UInt {
        return 0
    }
}

extension UInt8: Defaultable {
    static var defaultValue: UInt8 {
        return 0
    }
}

extension UInt16: Defaultable {
    static var defaultValue: UInt16 {
        return 0
    }
}

extension UInt32: Defaultable {
    static var defaultValue: UInt32 {
        return 0
    }
}

extension UInt64: Defaultable {
    static var defaultValue: UInt64 {
        return 0
    }
}

extension Float: Defaultable {
    static var defaultValue: Float {
        return 0
    }
}

extension Double: Defaultable {
    static var defaultValue: Double {
        return 0
    }
}

extension String: Defaultable {
    static var defaultValue: String {
        return ""
    }
}

extension Date: Defaultable {
    static var defaultValue: Date {
        return Date(timeIntervalSinceReferenceDate: 0)
    }
    
    static func defaultValue(for strategy: JSONDecoder.DateDecodingStrategy) -> Date {
        switch strategy {
        case .secondsSince1970, .millisecondsSince1970:
            return Date(timeIntervalSince1970: 0)
        default:
            return defaultValue
        }
    }
}

extension Data: Defaultable {
    static var defaultValue: Data {
        return Data()
    }
}

extension Decimal: Defaultable {
    static var defaultValue: Decimal {
        return Decimal(0)
    }
}
