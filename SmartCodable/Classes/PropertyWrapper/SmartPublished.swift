//
//  SmartPublished.swift
//  SmartCodable
//
//  Created by qixin on 2024/9/26.
//



/// 协议SmartPublishedProtocol，目标是为任何遵循该协议的类型提供统一的接口。
/// WrappedValue定义泛型类型，必须要求符合 Codable 协议。
/// createInstance方法，尝试给定义的值创建实例。
public protocol SmartPublishedProtocol {
    associatedtype WrappedValue: Codable
    init(wrappedValue: WrappedValue)
    
    static func createInstance(with value: Any) -> Self?
}

#if canImport(Combine) && swift(>=5.1)
import Foundation
import SwiftUI
import Combine


/// 这段代码实现了一个自定义的属性包装器 SmartPublished，
/// 将Combine 的发布功能与 Codable 的数据序列化能力结合。通过属性包装器简化属性的声明，同时支持相应式编程。
/// 用于结合 Combine 的功能和编码解码支持。以下是对整个代码的说明。
/// projectedValue提供一个发布者，可供订阅。
@propertyWrapper
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public struct SmartPublished<Value: Codable>: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Value.self)
        self.wrappedValue = value
        publisher = Publisher(wrappedValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.wrappedValue)
    }
    public var wrappedValue: Value {
        // willSet 观察器在 wrappedValue 被修改前调用，会将新的值通过 publisher 发送出去，从而通知所有的订阅者。这实现了数据更新的响应式特性。
        willSet {
            publisher.subject.send(newValue)
        }
    }
    
    public var projectedValue: Publisher {
        publisher
    }
    
    private var publisher: Publisher
    
    public struct Publisher: Combine.Publisher {
        public typealias Output = Value
        public typealias Failure = Never
        
        // CurrentValueSubject 是 Combine 中的一种 Subject，它会保存当前值并向新订阅者发送当前值。相比于 PassthroughSubject，它在初始化时就要求有一个初始值，因此更适合这种包装属性的场景。
        var subject: CurrentValueSubject<Value, Never>
        
        // 这个方法实现了 Publisher 协议，将 subscriber 传递给 subject，从而将订阅者连接到这个发布者上。
        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subject.subscribe(subscriber)
        }
        
        // Publisher 的构造函数接受一个初始值，并将其传递给 CurrentValueSubject 的初始化方法。
        init(_ output: Output) {
            subject = .init(output)
        }
    }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        publisher = Publisher(wrappedValue)
    }
    
    
    /// 这个下标实现了对属性包装器的自定义访问逻辑，用于在包装器内自定义 wrappedValue 的访问和修改行为。
    /// 参数解析：
    /// observed：观察者，即外部的 ObservableObject 实例。
    /// wrappedKeyPath：指向被包装值的引用键路径。
    /// storageKeyPath：指向属性包装器自身的引用键路径。
    public static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> Value {
        get {
            observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            // 在设置新值之前，如果 observed 的 objectWillChange 属性是 ObservableObjectPublisher 类型，则它会发送通知，确保在属性值更新之前，订阅者能收到通知。
            if let subject = observed.objectWillChange as? ObservableObjectPublisher {
                subject.send() // 修改 wrappedValue 之前
                observed[keyPath: storageKeyPath].wrappedValue = newValue
            }
        }
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
extension SmartPublished: WrapperLifecycle {
    func wrappedValueDidFinishMapping() -> SmartPublished<Value>? {
        if var temp = wrappedValue as? SmartDecodable {
            temp.didFinishMapping()
            return SmartPublished(wrappedValue: temp as! Value)
        }
        return nil
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
