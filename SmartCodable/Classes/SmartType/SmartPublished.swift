//
//  SmartPublished.swift
//  SmartCodable
//
//  Created by qixin on 2024/9/26.
//

#if canImport(Combine) && swift(>=5.1)
import Foundation
import SwiftUI
import Combine


/// 这段代码实现了一个自定义的属性包装器 SmartPublished，
/// 将Combine 的发布功能与 Codable 的数据序列化能力结合。通过属性包装器简化属性的声明，同时支持相应式编程。
/// 用于结合 Combine 的功能和编码解码支持。以下是对整个代码的说明。


/// 协议SmartPublishedProtocol，目标是为任何遵循该协议的类型提供统一的接口。
/// WrappedValue定义泛型类型，必须要求符合 Codable 协议。
/// createInstance方法，尝试给定义的值创建实例。
public protocol SmartPublishedProtocol {
    associatedtype WrappedValue: Codable
    init(wrappedValue: WrappedValue)
    
    static func createInstance(with value: Any) -> Self?
}

/// PublishedContainer
/// @Published使属性成为一个发布者，自动发布变更。
/// ObservableObject可以被SwiftUI或其他观察者订阅以监听其变化。
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public class PublishedContainer<Value>: ObservableObject {
    @Published public var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}


/// 属性包装器SmartPublished，允许在声明属性时附加额外的行为。
/// container使用PublishedContainer管理值和发布功能。
/// wrappedValue提供对实际值的访问。
/// projectedValue提供一个发布者，可供订阅。
@propertyWrapper
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public struct SmartPublished<Value: Codable>: Codable {
    private var container: PublishedContainer<Value>
    
    public var wrappedValue: Value {
        get { container.wrappedValue }
        set { container.wrappedValue = newValue }
    }
    
    public var projectedValue: Published<Value>.Publisher {
        container.$wrappedValue
    }
    
    public init(wrappedValue: Value) {
        self.container = PublishedContainer(wrappedValue: wrappedValue)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Value.self)
        self.container = PublishedContainer(wrappedValue: value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
}



/// 协议扩展
/// 使 SmartPublished 符合 SmartPublishedProtocol。
/// 利用泛型和类型检查，从任意值创建 SmartPublished 实例。
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
extension SmartPublished: SmartPublishedProtocol {
    public static func createInstance(with value: Any) -> SmartPublished? {
        if let value = value as? Value {
            return SmartPublished(wrappedValue: value)
        }
        return nil
    }
}
#else
#error("SmartPublished requires iOS 13 or later. Please update your deployment target.")
#endif







/**
 @propertyWrapper
 public struct AnySmartPublished<Value: Codable>: Codable {
     public var wrappedValue: Value
     
     public init(wrappedValue: Value) {
         self.wrappedValue = wrappedValue
     }
     
     public init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()
         self.wrappedValue = try container.decode(Value.self)
     }
     
     public func encode(to encoder: Encoder) throws {
         var container = encoder.singleValueContainer()
         try container.encode(wrappedValue)
     }
 }

 protocol SmartPublishedProtocol {
     associatedtype WrappedValue
     init(wrappedValue: WrappedValue)
     
     static func createInstance(with value: Any) -> Self?
 }

 extension AnySmartPublished: SmartPublishedProtocol {
     static func createInstance(with value: Any) -> AnySmartPublished? {
         if let value = value as? Value {
             return AnySmartPublished(wrappedValue: value)
         }
         return nil
     }
 }
 */




/**
 // 自定义的 PublishedCodable 属性包装器
 @propertyWrapper
 public class PublishedCodable<Value: Codable>: Codable {

     // 包含 Published 的属性
     @Published public var wrappedValue: Value

     // 用于暴露 Published 的 publisher
     public var projectedValue: Published<Value>.Publisher {
         return $wrappedValue
     }

     public init(wrappedValue: Value) {
         self.wrappedValue = wrappedValue
     }

     // 解码器的实现
     required public init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()
         self._wrappedValue = Published(wrappedValue: try container.decode(Value.self))
     }

     // 编码器的实现
     public func encode(to encoder: Encoder) throws {
         var container = encoder.singleValueContainer()
         try container.encode(wrappedValue)
     }
 }
 */
