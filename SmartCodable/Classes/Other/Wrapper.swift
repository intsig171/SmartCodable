//
//  Wrapper.swift
//  SmartCodable
//
//  Created by qixin on 2024/3/5.
//

import Foundation



//protocol DefaultValueProviding {
//    associatedtype Value
//    var defaultValue: Value { get }
//}
//
//
//
//@propertyWrapper
//public struct Backed<Value>: DefaultValueProviding where Value: Decodable {
//
//    private var _wrappedValue: Value?
//    public var wrappedValue: Value {
//        get {
//            guard let value = _wrappedValue else {
//                fatalError("\(type(of: self)).wrappedValue has been used before being initialized. This is a programming error.")
//            }
//            return value
//        }
//        set {
//            _wrappedValue = newValue
//        }
//    }
//
//    let defaultValue: Value
//
//    public init(wrappedValue: Value? = nil, defaultValue: Value) {
//        self.wrappedValue = wrappedValue ?? defaultValue
//        self.defaultValue = defaultValue
//    }
//}
//
//extension Backed: Decodable where Value: Decodable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        do {
//            self._wrappedValue = try container.decode(Value.self)
//        } catch {
//            print(error)
//            // No action needed, _wrappedValue remains nil or the default value
//        }
//    }
//}
//
//extension Backed: Encodable where Value: Encodable {
//    public func encode(to encoder: Encoder) throws {
//        try _wrappedValue?.encode(to: encoder)
//    }
//}


//@propertyWrapper
//public struct Backed<Value> {
//    private var _wrappedValue: Value?
//
//    public init(defaultValue: Value? = nil) {
//        self._wrappedValue = defaultValue
//    }
//
//    public var wrappedValue: Value {
//        get {
//            guard let value = _wrappedValue else {
//                fatalError("\(type(of: self)).wrappedValue has been used before being initialized. This is a programming error.")
//            }
//            return value
//        }
//        set {
//            _wrappedValue = newValue
//        }
//    }
//
//    public var projectedValue: Value? {
//        get { _wrappedValue }
//        set { _wrappedValue = newValue }
//    }
//}
//
//extension Backed: Decodable where Value: Decodable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        do {
//            self._wrappedValue = try container.decode(Value.self)
//        } catch {
//            print(error)
//            // No action needed, _wrappedValue remains nil or the default value
//        }
//    }
//}
//
//extension Backed: Encodable where Value: Encodable {
//    public func encode(to encoder: Encoder) throws {
//        try _wrappedValue?.encode(to: encoder)
//    }
//}
