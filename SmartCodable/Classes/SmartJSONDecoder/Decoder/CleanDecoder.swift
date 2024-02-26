// 
//  CleanDecoder.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/12/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

public protocol CleanDecoder: Decoder {
    
    var topContainer: Any { get }
    
    func decodeNil() -> Bool
    
    func decodeIfPresent(_ type: Bool.Type) throws -> Bool?
    
    func decodeIfPresent(_ type: Int.Type) throws -> Int?
    
    func decodeIfPresent(_ type: Int8.Type) throws -> Int8?
    
    func decodeIfPresent(_ type: Int16.Type) throws -> Int16?
    
    func decodeIfPresent(_ type: Int32.Type) throws -> Int32?
    
    func decodeIfPresent(_ type: Int64.Type) throws -> Int64?
    
    func decodeIfPresent(_ type: UInt.Type) throws -> UInt?
    
    func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8?
    
    func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16?
    
    func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32?
    
    func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64?
    
    func decodeIfPresent(_ type: Float.Type) throws -> Float?
    
    func decodeIfPresent(_ type: Double.Type) throws -> Double?
    
    func decodeIfPresent(_ type: String.Type) throws -> String?
    
    func decodeIfPresent(_ type: Date.Type) throws -> Date?
    
    func decodeIfPresent(_ type: Data.Type) throws -> Data?
    
    func decodeIfPresent(_ type: Decimal.Type) throws -> Decimal?
    
    func decodeIfPresent<T: Decodable>(_ type: T.Type) throws -> T?
}

// MARK: CleanDecoder Methods
extension _CleanJSONDecoder {
    
    var topContainer: Any {
        storage.topContainer
    }
    
    func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: String.Type) throws -> String? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Date.Type) throws -> Date? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Data.Type) throws -> Data? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent(_ type: Decimal.Type) throws -> Decimal? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decodeIfPresent<T: Decodable>(_ type: T.Type) throws -> T? {
        return try unbox(storage.topContainer, as: type)
    }
}
