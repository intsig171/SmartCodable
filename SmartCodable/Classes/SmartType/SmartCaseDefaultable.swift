//
//  CaseDefaultable.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/1.
//

// to see： https://github.com/line/line-sdk-ios-swift/blob/master/LineSDK/LineSDK/Networking/Model/CustomizeCoding/CodingExtension.swift

import Foundation

public protocol SmartCaseDefaultable: RawRepresentable, Codable, CaseIterable { }
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



public protocol SmartAssociatedEnumerable: Codable {
    static var defaultCase: Self { get }
    /// 如果你需要考虑encode，请实现它
    func encodeValue() -> Encodable?
}
extension SmartAssociatedEnumerable {
    public func encodeValue() -> Encodable? { return nil }
}

public extension SmartAssociatedEnumerable {
    init(from decoder: Decoder) throws {
        
        guard let _decoder = decoder as? JSONDecoderImpl else {
            let des = "Cannot initiali"
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: des))
        }
        
        let value = _decoder.json
        
        if let tranform = _decoder.cache.tranform(value: value, for: _decoder.codingPath.last) as? Self {
            self = tranform
        } else {
            throw DecodingError.valueNotFound(Self.self, DecodingError.Context.init(codingPath: _decoder.codingPath, debugDescription: "未对关联值枚举实现自定义解析策略"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = encodeValue() {
            try container.encode(value)
        }
    }
}
