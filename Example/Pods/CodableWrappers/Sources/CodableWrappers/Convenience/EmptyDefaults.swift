//
//  EmptyDefaults.swift
//  
//
//  Created by PJ Fechner on 7/10/20.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Convenience Defaults

/// Empty FallbackValueProvider for Bool: false
public struct EmptyBool: FallbackValueProvider {
    public static var defaultValue: Bool { false }
}

/// Empty FallbackValueProvider for String: ""
public struct EmptyString: FallbackValueProvider {
    public static var defaultValue: String { "" }
}

/// Empty FallbackValueProvider for Int: 0
public struct EmptyInt: FallbackValueProvider {
    public static var defaultValue: Int { 0 }
}
/// Empty FallbackValueProvider for Int16: 0
public struct EmptyInt16: FallbackValueProvider {
    public static var defaultValue: Int16 { 0 }
}
/// Empty FallbackValueProvider for Int32: 0
public struct EmptyInt32: FallbackValueProvider {
    public static var defaultValue: Int32 { 0 }
}
/// Empty FallbackValueProvider for Int64: 0
public struct EmptyInt64: FallbackValueProvider {
    public static var defaultValue: Int64 { 0 }
}
/// Empty FallbackValueProvider for Int8: 0
public struct EmptyInt8: FallbackValueProvider {
    public static var defaultValue: Int8 { 0 }
}
/// Empty FallbackValueProvider for UInt: 0
public struct EmptyUInt: FallbackValueProvider {
    public static var defaultValue: UInt { 0 }
}
/// Empty FallbackValueProvider for UInt16: 0
public struct EmptyUInt16: FallbackValueProvider {
    public static var defaultValue: UInt16 { 0 }
}
/// Empty FallbackValueProvider for UInt32: 0
public struct EmptyUInt32: FallbackValueProvider {
    public static var defaultValue: UInt32 { 0 }
}
/// Empty FallbackValueProvider for UInt64: 0
public struct EmptyUInt64: FallbackValueProvider {
    public static var defaultValue: UInt64 { 0 }
}
/// Empty FallbackValueProvider for UInt8: 0
public struct EmptyUInt8: FallbackValueProvider {
    public static var defaultValue: UInt8 { 0 }
}

#if canImport(UIKit)

/// Empty FallbackValueProvider for CGFloat: 0
public struct EmptyCGFloat: FallbackValueProvider {
    public static var defaultValue: CGFloat { 0 }
}
#endif

/// Empty FallbackValueProvider for Double: 0
public struct EmptyDouble: FallbackValueProvider {
    public static var defaultValue: Double { 0 }
}
/// Empty FallbackValueProvider for Float: 0
public struct EmptyFloat: FallbackValueProvider {
    public static var defaultValue: Float { 0 }
}

// Float16 is only available on ARM Macs.
#if swift(>=5.4) && !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
/// Empty FallbackValueProvider for Float16: 0
@available(iOS 14, macOS 11, tvOS 14.0, watchOS 7.0, macCatalyst 14.5, *)
public struct EmptyFloat16: FallbackValueProvider {
    @available(iOS 14, macOS 11, tvOS 14.0, watchOS 7.0, macCatalyst 14.5, *)
    public static var defaultValue: Float16 { 0 }
}
#endif

/// Empty FallbackValueProvider for Array: []
public struct EmptyArray<T>: FallbackValueProvider {
    public static var defaultValue: Array<T> { [] }
}
/// Empty FallbackValueProvider for Dictionary: [:]
public struct EmptyDictionary<Key: Hashable, Value>: FallbackValueProvider {
    public static var defaultValue: Dictionary<Key, Value> { [:] }
}
/// Empty FallbackValueProvider for Set: []
public struct EmptySet<T: Hashable>: FallbackValueProvider {
    public static var defaultValue: Set<T> { [] }
}


