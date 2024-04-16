//
//  CaseDefaultable.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/1.
//

// to see： https://github.com/line/line-sdk-ios-swift/blob/master/LineSDK/LineSDK/Networking/Model/CustomizeCoding/CodingExtension.swift

import Foundation

public protocol SmartCaseDefaultable: RawRepresentable, Codable { }

public extension SmartCaseDefaultable where Self: Decodable, Self.RawValue: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decoded = try container.decode(RawValue.self)
        if let v = Self.init(rawValue: decoded) {
            self = v
        } else {
            let des = "Cannot initialize \(Self.self) from invalid \(RawValue.self) value `\(decoded)`"
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: des))
        }
    }
}


