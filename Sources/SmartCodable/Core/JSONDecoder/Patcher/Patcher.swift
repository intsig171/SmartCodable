//
//  ValueCumulator.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/21.
//

import Foundation

struct Patcher<T> {
    
    static func defaultForType() throws -> T {
        return try Provider.defaultValue()
    }
    
    static func convertToType(from value: JSONValue?, impl: JSONDecoderImpl) -> T? {
        guard let value = value else { return nil }
        return Transformer.typeTransform(from: value, impl: impl)
    }
}

