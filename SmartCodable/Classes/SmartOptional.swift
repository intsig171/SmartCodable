//
//  CodableDefalutValue.swift
//  BTCodable
//
//  Created by qixin on 2023/7/31.
//

import Foundation


/** SmartOptional(解码的属性包装器) 使用的前提。设置这些障碍的目的是避免使用。
 * 并且必须是可选值类型（必须是class，不能是struct）
 * 必须是可选属性
 * 必须遵循了SmartDecodable协议
 */
public typealias SmartOptional<T: SmartDecodable & AnyObject> = DefalutDecodeWrapper<OptionalDecodeFailStrategy<T>>

/// 可选类型解码失败提供的默认值为nil
public struct OptionalDecodeFailStrategy<T: SmartDecodable & AnyObject>: DecodeFailable {
    public static var defaultValue: T? { nil }
}


/// 解码失败提供默认值
public protocol DecodeFailable {
    associatedtype Value: Decodable
    /// 解码失败，使用的默认值
    static var defaultValue: Value { get }
}


/// 使用合理的默认值解码值  可选解码
@propertyWrapper
public struct DefalutDecodeWrapper<Default: DecodeFailable> {
    public var wrappedValue: Default.Value
    
    public init(wrappedValue: Default.Value) {
        self.wrappedValue = wrappedValue
    }
}


extension DefalutDecodeWrapper: Decodable where Default.Value: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.wrappedValue = try container.decode(Default.Value.self)
        } catch {
            self.wrappedValue = Default.defaultValue
        }
    }
}

extension DefalutDecodeWrapper: Encodable where Default.Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension DefalutDecodeWrapper: Equatable where Default.Value: Equatable { }
extension DefalutDecodeWrapper: Hashable where Default.Value: Hashable { }





public extension KeyedDecodingContainer {
    func decode<P>(_ type: DefalutDecodeWrapper<P>.Type, forKey key: Key) throws -> DefalutDecodeWrapper<P> {
        // 可选值的情况下，不需要error兼容。
        if let value = optionalDecode(DefalutDecodeWrapper<P>.self, forKey: key) {
            return value
        } else {
            return DefalutDecodeWrapper(wrappedValue: P.defaultValue)
        }
    }
}


struct PropertyWrapperValue {
    /// 获取被SmartOptional属性包裹的值
    static func getSmartObject(decodeValue: Any) -> SmartDecodable? {
        if !"\(decodeValue)".contains("DefalutDecodeWrapper<OptionalDecodeFailStrategy<") {
            return nil
        }
        
        let mirror = Mirror(reflecting: decodeValue)
        // 肯定只有一个属性，即：被包裹的SmartDecodable的对象
        if mirror.children.count != 1 { return nil }
        if let child = mirror.children.first {
            if let temp = child.value as? SmartDecodable {
                return temp
            }
        }
        
        return nil
    }
}






