//
//  File.swift
//  
//
//  Created by PJ Fechner on 7/7/20.
//

import Foundation

//MARK: - Static Coding Protocols

/// Mirror of `Encodable`'s functionality but in a static context
/// - Attention: When implementing ensure an additional level of nesting is not introduced
public protocol StaticEncoder {
    /// The Type this encodes
    associatedtype OriginalType: Encodable

    /// Mirror of `Encodable`'s `encode(to: Encoder)` but in a static context
    static func encode(value: OriginalType, to encoder: Encoder) throws
}

/// Mirror of `Decodable`'s functionality but in a static context
/// - Attention: When implementing ensure an additional level of nesting is not introduced
public protocol StaticDecoder {
    /// The Type this will decode
    associatedtype DecodedType: Decodable

    /// Mirror of `Decodable`'s `init(from: Decoder)` but in a static context
    static func decode(from decoder: Decoder) throws -> DecodedType
}

/// Combines `StaticDecoder` and `StaticEncoder`
/// - Attention: When implementing ensure an additional level of nesting is not introduced
public protocol StaticCoder: StaticDecoder & StaticEncoder where DecodedType == OriginalType {
    /// `StaticDecoder.DecodedType` & `StaticEncoder.OriginalType`
    typealias CodingType = DecodedType
}
