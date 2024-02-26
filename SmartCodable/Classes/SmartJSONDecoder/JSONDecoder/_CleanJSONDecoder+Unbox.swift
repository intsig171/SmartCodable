// 
//  _CleanJSONDecoder+Unbox.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

extension _CleanJSONDecoder {
    
    /// Returns the given value unboxed from a container.
    func unbox(_ value: Any, as type: Bool.Type) throws -> Bool? {
        guard !(value is NSNull) else { return nil }
        
        if let number = value as? NSNumber {
            // TODO: Add a flag to coerce non-boolean numbers into Bools?
            if number === kCFBooleanTrue as NSNumber {
                return true
            } else if number === kCFBooleanFalse as NSNumber {
                return false
            }
            
            /* FIXME: If swift-corelibs-foundation doesn't change to use NSNumber, this code path will need to be included and tested:
             } else if let bool = value as? Bool {
             return bool
             */
            
        }
        
        return nil
    }
    
    func unbox(_ value: Any, as type: Int.Type) throws -> Int? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let int = number.intValue
        guard NSNumber(value: int) == number else {
            return nil
        }
        
        return int
    }
    
    func unbox(_ value: Any, as type: Int8.Type) throws -> Int8? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let int8 = number.int8Value
        guard NSNumber(value: int8) == number else {
            return nil
        }
        
        return int8
    }
    
    func unbox(_ value: Any, as type: Int16.Type) throws -> Int16? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let int16 = number.int16Value
        guard NSNumber(value: int16) == number else {
            return nil
        }
        
        return int16
    }
    
    func unbox(_ value: Any, as type: Int32.Type) throws -> Int32? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let int32 = number.int32Value
        guard NSNumber(value: int32) == number else {
            return nil
        }
        
        return int32
    }
    
    func unbox(_ value: Any, as type: Int64.Type) throws -> Int64? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let int64 = number.int64Value
        guard NSNumber(value: int64) == number else {
            return nil
        }
        
        return int64
    }
    
    func unbox(_ value: Any, as type: UInt.Type) throws -> UInt? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let uint = number.uintValue
        guard NSNumber(value: uint) == number else {
            return nil
        }
        
        return uint
    }
    
    func unbox(_ value: Any, as type: UInt8.Type) throws -> UInt8? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let uint8 = number.uint8Value
        guard NSNumber(value: uint8) == number else {
            return nil
        }
        
        return uint8
    }
    
    func unbox(_ value: Any, as type: UInt16.Type) throws -> UInt16? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let uint16 = number.uint16Value
        guard NSNumber(value: uint16) == number else {
            return nil
        }
        
        return uint16
    }
    
    func unbox(_ value: Any, as type: UInt32.Type) throws -> UInt32? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let uint32 = number.uint32Value
        guard NSNumber(value: uint32) == number else {
            return nil
        }
        
        return uint32
    }
    
    func unbox(_ value: Any, as type: UInt64.Type) throws -> UInt64? {
        guard !(value is NSNull) else { return nil }
        
        guard let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse else {
                return nil
        }
        
        let uint64 = number.uint64Value
        guard NSNumber(value: uint64) == number else {
            return nil
        }
        
        return uint64
    }
    
    func unbox(_ value: Any, as type: Float.Type) throws -> Float? {
        guard !(value is NSNull) else { return nil }
        
        if let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse {
            // We are willing to return a Float by losing precision:
            // * If the original value was integral,
            //   * and the integral value was > Float.greatestFiniteMagnitude, we will fail
            //   * and the integral value was <= Float.greatestFiniteMagnitude, we are willing to lose precision past 2^24
            // * If it was a Float, you will get back the precise value
            // * If it was a Double or Decimal, you will get back the nearest approximation if it will fit
            let double = number.doubleValue
            guard abs(double) <= Double(Float.greatestFiniteMagnitude) else {
                return nil
            }
            
            return Float(double)
            
            /* FIXME: If swift-corelibs-foundation doesn't change to use NSNumber, this code path will need to be included and tested:
             } else if let double = value as? Double {
             if abs(double) <= Double(Float.max) {
             return Float(double)
             }
             
             overflow = true
             } else if let int = value as? Int {
             if let float = Float(exactly: int) {
             return float
             }
             
             overflow = true
             */
            
        } else if let string = value as? String,
            case .convertFromString(let posInfString, let negInfString, let nanString) = self.options.nonConformingFloatDecodingStrategy {
            if string == posInfString {
                return Float.infinity
            } else if string == negInfString {
                return -Float.infinity
            } else if string == nanString {
                return Float.nan
            }
        }
        
        return nil
    }
    
    func unbox(_ value: Any, as type: Double.Type) throws -> Double? {
        guard !(value is NSNull) else { return nil }
        
        if let number = value as? NSNumber,
            number !== kCFBooleanTrue,
            number !== kCFBooleanFalse {
            // We are always willing to return the number as a Double:
            // * If the original value was integral, it is guaranteed to fit in a Double; we are willing to lose precision past 2^53 if you encoded a UInt64 but requested a Double
            // * If it was a Float or Double, you will get back the precise value
            // * If it was Decimal, you will get back the nearest approximation
            return number.doubleValue
            
            /* FIXME: If swift-corelibs-foundation doesn't change to use NSNumber, this code path will need to be included and tested:
             } else if let double = value as? Double {
             return double
             } else if let int = value as? Int {
             if let double = Double(exactly: int) {
             return double
             }
             
             overflow = true
             */
            
        } else if let string = value as? String,
            case .convertFromString(let posInfString, let negInfString, let nanString) = self.options.nonConformingFloatDecodingStrategy {
            if string == posInfString {
                return Double.infinity
            } else if string == negInfString {
                return -Double.infinity
            } else if string == nanString {
                return Double.nan
            }
        }
        
        return nil
    }
    
    func unbox(_ value: Any, as type: String.Type) throws -> String? {
        guard !(value is NSNull) else { return nil }
        
        guard let string = value as? String else { return nil }
        
        return string
    }
    
    func unbox(_ value: Any, as type: Date.Type) throws -> Date? {
        guard !(value is NSNull) else { return nil }
        
        switch self.options.dateDecodingStrategy {
        case .deferredToDate:
            self.storage.push(container: value)
            defer { self.storage.popContainer() }
            guard let double = try self.unbox(value, as: Double.self) else { return nil }
            
            return Date(timeIntervalSinceReferenceDate: double)
            
        case .secondsSince1970:
            guard let double = try self.unbox(value, as: Double.self) else { return nil }
            
            return Date(timeIntervalSince1970: double)
            
        case .millisecondsSince1970:
            guard let double = try self.unbox(value, as: Double.self) else { return nil }
            
            return Date(timeIntervalSince1970: double / 1000.0)
            
        case .iso8601:
            if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                guard let string = try self.unbox(value, as: String.self) else { return nil }
                guard let date = _iso8601Formatter.date(from: string) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
                }
                
                return date
            } else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }
            
        case .formatted(let formatter):
            guard let string = try self.unbox(value, as: String.self) else { return nil }
            
            return formatter.date(from: string)
            
        case .custom(let closure):
            self.storage.push(container: value)
            defer { self.storage.popContainer() }
            
            return try closure(self)
            
        @unknown default:
            self.storage.push(container: value)
            defer { self.storage.popContainer() }
            guard let double = try self.unbox(value, as: Double.self) else { return nil }
            
            return Date(timeIntervalSinceReferenceDate: double)
        }
    }
    
    func unbox(_ value: Any, as type: Data.Type) throws -> Data? {
        guard !(value is NSNull) else { return nil }
        
        switch self.options.dataDecodingStrategy {
        case .deferredToData:
            self.storage.push(container: value)
            defer { self.storage.popContainer() }
            return try Data(from: self)
            
        case .base64:
            guard let string = value as? String else { return nil }
            
            guard let data = Data(base64Encoded: string) else { return nil }
            
            return data
            
        case .custom(let closure):
            self.storage.push(container: value)
            defer { self.storage.popContainer() }
            return try closure(self)
        @unknown default:
            self.storage.push(container: value)
            defer { self.storage.popContainer() }
            return try Data(from: self)
        }
    }
    
    func unbox(_ value: Any, as type: URL.Type) throws -> URL? {
        guard let string = try unbox(value, as: String.self) else { return nil }
        
        return URL(string: string)
    }
    
    func unbox(_ value: Any, as type: Decimal.Type) throws -> Decimal? {
        guard !(value is NSNull) else { return nil }
        
        // Attempt to bridge from NSDecimalNumber.
        if let decimal = value as? Decimal {
            return decimal
        } else {
            guard let doubleValue = try self.unbox(value, as: Double.self) else { return nil }
            
            return Decimal(doubleValue)
        }
    }
    
    func unbox<T>(_ value: Any, as type: _JSONStringDictionaryDecodableMarker.Type) throws -> T? {
        guard !(value is NSNull) else { return nil }
        
        guard let dict = value as? NSDictionary else { return nil }
        
        var result = [String : Any]()
        let elementType = type.elementType
        for (key, value) in dict {
            let key = key as! String
            self.codingPath.append(CleanJSONKey(stringValue: key, intValue: nil))
            defer { self.codingPath.removeLast() }
            
            result[key] = try unbox_(value, as: elementType)
        }
        
        return result as? T
    }
    
    func unbox<T : Decodable>(_ value: Any, as type: T.Type) throws -> T? {
        return try unbox_(value, as: type) as? T
    }
    
    func unbox_(_ value: Any, as type: Decodable.Type) throws -> Any? {
        if type == Date.self || type == NSDate.self {
            return try unbox(value, as: Date.self)
        } else if type == Data.self || type == NSData.self {
            return try unbox(value, as: Data.self)
        } else if type == URL.self || type == NSURL.self {
            return try unbox(value, as: URL.self)
        } else if type == Decimal.self || type == NSDecimalNumber.self {
            return try unbox(value, as: Decimal.self)
        } else if let stringKeyedDictType = type as? _JSONStringDictionaryDecodableMarker.Type {
            return try unbox(value, as: stringKeyedDictType)
        } else {
            storage.push(container: value)
            defer { storage.popContainer() }
            return try type.init(from: self)
        }
    }
}

// MARK: - helper
#if arch(i386) || arch(arm)
protocol _JSONStringDictionaryDecodableMarker {
    static var elementType: Decodable.Type { get }
}
#else
protocol _JSONStringDictionaryDecodableMarker {
    static var elementType: Decodable.Type { get }
}
#endif

extension Dictionary : _JSONStringDictionaryDecodableMarker where Key == String, Value: Decodable {
    static var elementType: Decodable.Type { return Value.self }
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
private var _iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    return formatter
}()
