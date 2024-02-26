// 
//  CaseDefaultable.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/11/30
//  Copyright © 2018 Pircate. All rights reserved.
//
//  Reference: https://github.com/line/line-sdk-ios-swift/blob/master/LineSDK/LineSDK/Networking/Model/CustomizeCoding/CodingExtension.swift

import Foundation

public protocol CaseDefaultable: RawRepresentable {
    
    static var defaultCase: Self { get }
}

public extension CaseDefaultable where Self: Decodable, Self.RawValue: Decodable {
    
    init(from decoder: Decoder) throws {
        guard let _decoder = decoder as? _CleanJSONDecoder else {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(RawValue.self)
            self = Self.init(rawValue: rawValue) ?? Self.defaultCase
            return
        }
        
        self = try _decoder.decodeCase(Self.self)
    }
}

private extension _CleanJSONDecoder {
    
    func decodeCase<T>(_ type: T.Type) throws -> T
        where T: CaseDefaultable,
        T: Decodable,
        T.RawValue: Decodable
    {
        guard !decodeNil(), !storage.containers.isEmpty, storage.topContainer is T.RawValue else {
            return T.defaultCase
        }
        
        if let number = storage.topContainer as? NSNumber,
            (number === kCFBooleanTrue || number === kCFBooleanFalse) {
            guard let rawValue = number.boolValue as? T.RawValue else {
                return T.defaultCase
            }
            
            return T.init(rawValue: rawValue) ?? T.defaultCase
        }
        
        let rawValue = try decode(T.RawValue.self)
        return T.init(rawValue: rawValue) ?? T.defaultCase
    }
}
