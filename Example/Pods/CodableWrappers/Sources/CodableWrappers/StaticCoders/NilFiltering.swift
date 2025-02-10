//
//  NilFiltering.swift
//  
//
//  Created by PJ Fechner on 7/10/20.
//

import Foundation

/// Decodes an array, removing any nil values
public struct ArrayNilFilteringStaticDecoder<T: Decodable>: StaticDecoder {
    public static func decode(from decoder: Decoder) throws -> Array<T> {
        var container = try decoder.unkeyedContainer()
        return try container.filteringNils()
    }
}

/// Uses Decodes a Set, removing any nil values
public struct SetNilFilteringStaticDecoder<T: Decodable>: StaticDecoder where T: Hashable {
    public static func decode(from decoder: Decoder) throws -> Set<T> {
        var container = try decoder.unkeyedContainer()
        return try Set(container.filteringNils())
    }
}

/// Uses Decodes a dictionary, removing any nil values
public struct DictionaryNilFilteringStaticDecoder<T: Decodable, Key: Decodable>: StaticDecoder where Key: Hashable {
    public static func decode(from decoder: Decoder) throws -> [Key:T] {
        try Dictionary<Key, T?>(from: decoder).compactMapValues{$0}
    }
}

extension UnkeyedDecodingContainer {
    ///This decodes real items while filtering any nil values.
    @inlinable mutating func filteringNils<T: Decodable>() throws -> [T] {
        var items: [T] = []
        while !isAtEnd {
            // At least for PLists, `decodeIfPresent` seems to break when a value is `$null`.
            // This is why `Optional<T>` is required
            if let item = try decodeIfPresent(Optional<T>.self) as? T {
                items.append(item)
            }
        }
        return items
    }
}
