//
//  CodableDefalutValue.swift
//  BTCodable
//
//  Created by qixin on 2023/7/31.
//

import Foundation


/// Smart属性包装器，用于修饰可选的模型属性。
///
/// 使用要求：
/// - 并且必须是可选值类型（必须是class，不能是struct）
/// - 必须是可选属性
/// - 必须遵循了SmartDecodable协议
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
        
        
        /**
         Mirror和reflect库在Swift中是相关的，但是它们并不完全相同。

         Reflect库是Swift早期版本中用于反射的库，但自Swift 5.1起已被标记为废弃。Reflect库提供了一些基本的反射功能，例如获取类型的名称和成员信息。然而，由于其功能有限，Swift引入了更强大和灵活的反射机制。

         Mirror类型是Swift中用于反射的主要工具。它提供了一种机制，可以检查和访问Swift类型的属性、方法和其他成员。Mirror类型可以通过实例化Mirror结构体来创建一个类型的镜像，然后可以使用镜像来获取类型的信息。Mirror类型在Swift标准库中是一个常用的工具，用于实现调试、序列化和其他需要动态访问类型信息的功能。

         因此，Mirror类型是Swift中更现代和推荐的反射机制，而reflect库已被废弃。
         */
        
        
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






