// 
//  _SmartJSONDecoder+Unbox.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//
import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#else
import Cocoa
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
public typealias ColorObject = UIColor
#else
public typealias ColorObject = NSColor
#endif


extension _SmartJSONDecoder {
    func unbox(_ value: Any, as type: Bool.Type) throws -> Bool? {

        guard !(value is NSNull) else { return nil }
        
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Bool {
            return tranform
        }
        
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
        throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
    }
    
    func unbox(_ value: Any, as type: Int.Type) throws -> Int? {
      
        guard !(value is NSNull) else { return nil }
        
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Int {
            return tranform
        }
        
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        
        // To prevent storing non-Int values in NSNumber.
        /**
         let double: Double = 1.234
         let number = NSNumber.init(floatLiteral: double)
         let intValue = number.intValue
         print(intValue)  // 1
         */
        let int = number.intValue
        guard NSNumber(value: int) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return int
    }
    
    func unbox(_ value: Any, as type: Int8.Type) throws -> Int8? {
      
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Int8 {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let int8 = number.int8Value
        guard NSNumber(value: int8) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return int8
    }
    
    func unbox(_ value: Any, as type: Int16.Type) throws -> Int16? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Int16 {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let int16 = number.int16Value
        guard NSNumber(value: int16) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return int16
    }
    
    func unbox(_ value: Any, as type: Int32.Type) throws -> Int32? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Int32 {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let int32 = number.int32Value
        guard NSNumber(value: int32) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return int32
    }
    
    func unbox(_ value: Any, as type: Int64.Type) throws -> Int64? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Int64 {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let int64 = number.int64Value
        guard NSNumber(value: int64) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return int64
    }
    
    func unbox(_ value: Any, as type: UInt.Type) throws -> UInt? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? UInt {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let uint = number.uintValue
        guard NSNumber(value: uint) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return uint
    }
    
    func unbox(_ value: Any, as type: UInt8.Type) throws -> UInt8? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? UInt8 {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let uint8 = number.uint8Value
        guard NSNumber(value: uint8) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return uint8
    }
    
    func unbox(_ value: Any, as type: UInt16.Type) throws -> UInt16? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? UInt16 {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let uint16 = number.uint16Value
        guard NSNumber(value: uint16) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return uint16
    }
    
    func unbox(_ value: Any, as type: UInt32.Type) throws -> UInt32? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? UInt32 {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let uint32 = number.uint32Value
        guard NSNumber(value: uint32) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return uint32
    }
    
    func unbox(_ value: Any, as type: UInt64.Type) throws -> UInt64? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? UInt64 {
            return tranform
        }
        guard let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        let uint64 = number.uint64Value
        guard NSNumber(value: uint64) == number else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number <\(number)> does not fit in \(type)."))
        }
        
        return uint64
    }
    
    func unbox(_ value: Any, as type: Float.Type) throws -> Float? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Float {
            return tranform
        }
        if let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse {
            // We are willing to return a Float by losing precision:
            // * If the original value was integral,
            //   * and the integral value was > Float.greatestFiniteMagnitude, we will fail
            //   * and the integral value was <= Float.greatestFiniteMagnitude, we are willing to lose precision past 2^24
            // * If it was a Float, you will get back the precise value
            // * If it was a Double or Decimal, you will get back the nearest approximation if it will fit
            let double = number.doubleValue
            guard abs(double) <= Double(Float.greatestFiniteMagnitude) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Parsed JSON number \(number) does not fit in \(type)."))
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
            
            
            // nan & inf 字符串的处理
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
        
        throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
    }
    
    func unbox(_ value: Any, as type: CGFloat.Type) throws -> CGFloat? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? CGFloat {
            return tranform
        }

        if let double = try unbox(value, as: Double.self) {
            return CGFloat(double)
        }
        return nil
    }
    
    func unbox(_ value: Any, as type: Double.Type) throws -> Double? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Double {
            return tranform
        }
        if let number = value as? NSNumber, number !== kCFBooleanTrue, number !== kCFBooleanFalse {
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
        
        /** 注意 inf
         * String类型的 “inf”，可以直接转成Double类型，代表无穷大和无穷小。
         * Swift 能够识别 "inf", "+inf", "-inf", "Infinity", "+Infinity", 和 "-Infinity" 这些表示形式，将它们转换为相应的无穷大或无穷小的 Double 值。
         *
         * 注意 nan
         * String类型的 “nan”，可以直接转成Double类型，代表不是一个数（Not a Number）的特殊值。
         * Swift 能够识别 "NaN", "Nan", "nan" 这些表示形式,并将其转换为表示不是一个数的 Double 值.
         */
        
        throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
    }
    
    func unbox(_ value: Any, as type: String.Type) throws -> String? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? String {
            return tranform
        }
        guard let string = value as? String else {
            throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
        }
        
        return string
    }
    
    func unbox(_ value: Any, as type: Date.Type) throws -> Date? {
        guard !(value is NSNull) else { return nil }
        
        // Prioritize the parsing strategy for individual properties
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Date {
            return tranform
        }
        
        switch self.options.dateDecodingStrategy {
        case .deferredToDate:

            var double: Double?
            if let temp = try? self.unbox(value, as: Double.self) {
                double = temp
            } else if let temp = try? self.unbox(value, as: String.self) {
                double = Double(temp)
            }
            guard let double = double else { return nil }
            return Date(timeIntervalSinceReferenceDate: double)
            
        case .secondsSince1970:
            guard let double = try self.unbox(value, as: Double.self) else { return nil }
            return Date(timeIntervalSince1970: double)
            
        case .millisecondsSince1970:
            guard let double = try self.unbox(value, as: Double.self) else { return nil }
            return Date(timeIntervalSince1970: double / 1000.0)
            
        case .iso8601:
            if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                guard let string = try self.unbox(value, as: String.self) else { return nil }
                guard let date = _iso8601Formatter.date(from: string) else {
                    return nil
                }
                
                return date
            } else {
                return nil
            }
            
        case .formatted(let formatter):
            guard let string = try self.unbox(value, as: String.self) else { return nil }
            guard let date = formatter.date(from: string) else {
                return nil
            }
            
            return date
            
        case .custom(let closure):
            self.storage.push(container: value)
            let date = try closure(self)
            self.storage.popContainer()
            return date
        @unknown default:
            return nil
        }
    }
    
    func unbox(_ value: Any, as type: Data.Type) throws -> Data? {
        guard !(value is NSNull) else { return nil }
        
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Data {
            return tranform
        }
        
        switch self.options.dataDecodingStrategy {
        case .deferredToData:
            self.storage.push(container: value)
            let data = try Data(from: self)
            self.storage.popContainer()
            return data
            
        case .base64:
            guard let string = value as? String else {
                throw DecodingError._typeMismatch(at: self.codingPath, expectation: type, reality: value)
            }
            
            guard let data = Data(base64Encoded: string) else {
                return nil
            }
            
            return data
            
        case .custom(let closure):
            self.storage.push(container: value)
            let data = try closure(self)
            self.storage.popContainer()
            return data
        @unknown default:
            return nil
        }
    }
    
    func unbox(_ value: Any, as type: Decimal.Type) throws -> Decimal? {
        guard !(value is NSNull) else { return nil }
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? Decimal {
            return tranform
        }
        // Attempt to bridge from NSDecimalNumber.
        if let decimal = value as? Decimal {
            return decimal
        } else {
            let doubleValue = try self.unbox(value, as: Double.self)!
            return Decimal(doubleValue)
        }
    }
    
    func unbox(_ value: Any, as type: URL.Type) throws -> URL? {
        guard !(value is NSNull) else { return nil }
        guard let urlString = try self.unbox(value, as: String.self) else { return nil }
        
        // 优先处理单个属性的解析策略
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? URL {
            return tranform
        }

        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func unbox(_ value: Any, as type: ColorObject.Type) throws -> ColorObject? {
        guard !(value is NSNull) else { return nil }
        guard let colorString = try self.unbox(value, as: String.self) else { return nil }
        
        // 优先处理单个属性的解析策略
        if let tranform = cache.tranform(decodedValue: value, for: codingPath) as? ColorObject {
            return tranform
        }
       
        
        return ColorObject.hex(colorString)
    }
    
    func unbox(_ value: Any, as type: SmartAny.Type) throws -> SmartAny? {
        guard !(value is NSNull) else { return nil }

        if let temp = try? unbox(value, as: String.self) {
            return .string(temp)
        } else if let temp = try? unbox(value, as: Bool.self) as? NSNumber {
            return .number(temp)
        }
        
        else if let temp = try? unbox(value, as: Double.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: CGFloat.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: Float.self) as? NSNumber {
            return .number(temp)
        }
        
        else if let temp = try? unbox(value, as: Int.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: Int8.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: Int16.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: Int32.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: Int64.self) as? NSNumber {
            return .number(temp)
        }
        
        else if let temp = try? unbox(value, as: UInt.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: UInt8.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: UInt16.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: UInt32.self) as? NSNumber {
            return .number(temp)
        } else if let temp = try? unbox(value, as: UInt64.self) as? NSNumber {
            return .number(temp)
        }
        


        return nil
    }

    
    func unbox<T : Decodable>(_ value: Any, as type: T.Type) throws -> T? {
                    
        let decoded: T?
        if T.self == Date.self || T.self == NSDate.self {
            guard let date = try self.unbox(value, as: Date.self) else { return nil }
            decoded = date as? T
        } else if T.self == Data.self || T.self == NSData.self {
            guard let data = try self.unbox(value, as: Data.self) else { return nil }
            decoded = data as? T
        } else if T.self == URL.self || T.self == NSURL.self {
            guard let url = try self.unbox(value, as: URL.self) else { return nil }
            decoded = (url as! T)
        } else if T.self == Decimal.self || T.self == NSDecimalNumber.self {
            guard let decimal = try self.unbox(value, as: Decimal.self) else { return nil }
            decoded = decimal as? T
        } else if T.self == CGFloat.self { // 支持CGFloat的可选解码的兼容。
            guard let float = try self.unbox(value, as: CGFloat.self) else { return nil }
            decoded = float as? T
        } else {
            
            // Please see the description1⃣️
            if let _ = [] as? T {
                // 如果T是数组类型，但value不是数组，则直接返回nil
                guard value is [Any] || value is String else { return nil }
            } else if let _ = [:] as? T {
                // 如果T是字典类型，但value不是字典，则直接返回nil
                guard value is [String: Any] else { return nil }
            }
            

            let v = ModelKeyMapper<T>.convertToMappedFormat(value)
            self.storage.push(container: v)

            
            cache.cacheInitialState(for: type)
            
            // Please see the description2⃣️
            decoded = try T(from: self)
            storage.popContainer()
            
            cache.clearLastState(for: type)            
        }
        return decoded
    }
}


@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate var _iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    return formatter
}()




/** description1⃣️
 * 避免可选属性是数组或字典的时候，通过 `try T(from: self)` 创建一个新的值。
 * 为什么基础数据类型（例如：Int，String）不需要这么处理？
 *  - 因为这些基本类型有对应的unbox方法。字典和数组涉及到范型的处理，没法这么设计。
 *
 ** Avoids creating a new value using `try T(from: self)` when the optional property is an array or dictionary.
 * Why don't basic data types (e.g., Int, String) require this treatment?
 *  - Because these basic types have corresponding unbox methods. Dictionaries and arrays involve generic processing, which can't be designed this way.
 */


/** description2⃣️
 * decoded = try T(from: self)。这行代码是Swift中Codable解析的关键部分。
 * 目的：将外部数据源获取的原始数据转换为Swift中具体的类型。
 * 含义：“尝试使用当前的解码器（self）作为数据源来创建一个类型为 T 的新实例。”这一过程可能会抛出错误，因为数据可能与 T 类型不匹配，或者数据本身就是不完整或不正确的，所以这个调用是一个 try 表达式，需要被 catch 语句捕获错误或者使用 try? 或 try! 来处理。（这里的 T 指的是遵守 Decodable 协议的任意类型。该代码尝试通过调用类型 T 的 init(from:) 初始化器来创建该类型的实例，这个初始化器是 Decodable 协议的一部分。self 在这里指的是解码器本身，通常是一个 Decoder实例，它持有或者可以访问要解码的数据。）
 * 解析：
 * - 如果T是一个模型或模型数组：会nestedContainer 或 nestedUnkeyedContainer 创建一个容器。在容器中持有了_SmartJSONDecoder，解析属性。
 * - 如果是属性，会根据是否可选，调用decode或decodeIfPresent方法完成解析。
 *
 *
 ** decoded = try T(from: self). This line of code is a key part of Codable parsing in Swift.
 * Purpose: To convert raw data obtained from an external data source into a specific type in Swift.
 * Meaning: "Attempts to create a new instance of type T using the current decoder (self) as the data source." This process may throw an error because the data may not match the T type, or the data itself is incomplete or incorrect, thus this call is a try expression and needs to be caught by a catch statement or handled using try? or try! (Here, T refers to any type that conforms to the Decodable protocol. This code attempts to create an instance of type T by calling the init(from:) initializer of type T, which is part of the Decodable protocol. self here refers to the decoder itself, usually a Decoder instance, which holds or has access to the data to be decoded.)
 * Parsing:
 * - If T is a model or an array of models: It will create a container using nestedContainer or nestedUnkeyedContainer. The container holds a _SmartJSONDecoder, parsing the properties.
 * - If it is a property, it will complete the parsing by calling the decode or decodeIfPresent method depending on whether it is optional.
 *
 *
 */
