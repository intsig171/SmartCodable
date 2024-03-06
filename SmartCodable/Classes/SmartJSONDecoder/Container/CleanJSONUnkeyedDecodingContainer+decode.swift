//
//  CleanJSONUnkeyedDecodingContainer+decode.swift
//  SmartCodable
//
//  Created by qixin on 2024/2/28.
//

import Foundation

extension CleanJSONUnkeyedDecodingContainer {
    fileprivate func didFinishMapping<T: Decodable>(_ decodeValue: T) -> T {
        return DecodingProcessCoordinator.didFinishMapping(decodeValue)
    }
    
    
    fileprivate mutating func explicitDecode<T: Decodable>(_ type: T.Type) throws -> T {
        guard !self.isAtEnd else { return try decodeIfAtEnd(type: type) }
        
        self.decoder.codingPath.append(SmartCodingKey(index: self.currentIndex))
        defer { self.decoder.codingPath.removeLast() }

        let entry = self.container[self.currentIndex]
        
        var decoded: T
        if let value = try? self.decoder.unbox(entry, as: type) {
            decoded = value
        } else {
            decoded = try Patcher<T>.patchWithConvertOrDefault(value: entry)
        }
        
        self.currentIndex += 1

        return didFinishMapping(decoded)
    }
    
    private mutating func decodeIfAtEnd<T: Decodable>(type: T.Type) throws -> T {
        
        do {
            let value = try Patcher<T>.defaultForType()
            self.currentIndex += 1
            return value
        } catch {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: self.decoder.codingPath + [SmartCodingKey(index: self.currentIndex)], debugDescription: "Unkeyed container is at end."))
        }
    }
}

extension CleanJSONUnkeyedDecodingContainer {
    public mutating func decode(_ type: Bool.Type) throws -> Bool {
        return try explicitDecode(Bool.self)
    }

    public mutating func decode(_ type: Int.Type) throws -> Int {
        return try explicitDecode(Int.self)
    }
    
    public mutating func decode(_ type: Int8.Type) throws -> Int8 {
        return try explicitDecode(Int8.self)
    }
    
    public mutating func decode(_ type: Int16.Type) throws -> Int16 {
        return try explicitDecode(Int16.self)
    }
    
    public mutating func decode(_ type: Int32.Type) throws -> Int32 {
        return try explicitDecode(Int32.self)
    }
    
    public mutating func decode(_ type: Int64.Type) throws -> Int64 {
        return try explicitDecode(Int64.self)
    }
    
    public mutating func decode(_ type: UInt.Type) throws -> UInt {
        return try explicitDecode(UInt.self)
    }
    
    public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try explicitDecode(UInt8.self)
    }
    
    public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try explicitDecode(UInt16.self)
    }
    
    public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try explicitDecode(UInt32.self)
    }
    
    public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try explicitDecode(UInt64.self)
    }
    
    public mutating func decode(_ type: Float.Type) throws -> Float {
        return try explicitDecode(Float.self)
    }
    
    public mutating func decode(_ type: Double.Type) throws -> Double {
        return try explicitDecode(Double.self)
    }
    
    public mutating func decode(_ type: String.Type) throws -> String {
        return try explicitDecode(String.self)
    }
    
    public mutating func decode<T : Decodable>(_ type: T.Type) throws -> T {
        return try explicitDecode(type)
    }
}
