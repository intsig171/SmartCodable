//
//  CodingKey.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/1.
//

import Foundation


/// 全局（本次解析）的KeyDecodingStrategy映射关系。
public struct SmartGlobalMap {
    var from: String
    var to: String

    public init(from: String, to: String) {
        self.from = from
        self.to = to
    }
}

/// 指定路径的KeyDecodingStrategy映射关系。
/// let dict: [String : Any] = [
/// "name": "Mccc",
/// "subs": [[
///    "nickName": "Mccc",
///    "subSex": [
///        "sexName": "男"
///    ]
///  ]]
/// ]
///
/// 如果想要将sexName映射为"sex": SmartExactMap(path: "subs.subSex", from: "sexName", to: "sex")
public struct SmartExactMap {
    var path: String
    var from: String
    var to: String
    
    public init(path: String, from: String, to: String) {
        self.path = path
        self.from = from
        self.to = to
    }
}


extension JSONDecoder {
    public enum SmartDecodingKey {
        /// 使用默认key
        case useDefaultKeys
        
        /// 蛇形命名转换成驼峰命名
        case convertFromSnakeCase
        
        /// 自定义映射关系，会覆盖本次所有映射。
        case globalMap([SmartGlobalMap])
        
        /// 自定义映射关系，仅作用于path路径对应的映射。
        case exactMap([SmartExactMap])
        
        func toSystem() -> JSONDecoder.KeyDecodingStrategy {
            switch self {
            case .useDefaultKeys:
                return JSONDecoder.KeyDecodingStrategy.useDefaultKeys
            case .convertFromSnakeCase:
                return JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
            case .globalMap(let maps):
                return JSONDecoder.KeyDecodingStrategy.mapper( maps )
            case .exactMap(let maps):
                return JSONDecoder.KeyDecodingStrategy.mapperExact( maps )
            }
        }
    }
}

extension JSONDecoder.KeyDecodingStrategy {
    public static func mapper(_ container: [SmartGlobalMap]) -> JSONDecoder.KeyDecodingStrategy {
        let mapping = Dictionary(container.map { ($0.from, $0.to) }, uniquingKeysWith: { first, _ in first })
        return .custom { CodingKeysConverter(mapping: mapping)($0) }
    }

    public static func mapperExact(_ container: [SmartExactMap]) -> JSONDecoder.KeyDecodingStrategy {
        let mapping = Dictionary(container.map { map in
            let fullPath = map.path.isEmpty ? map.from : "\(map.path).\(map.from)"
            return (fullPath, map.to)
        }, uniquingKeysWith: { first, _ in first })
        return .custom { CodingKeysExactConverter(mapping: mapping)($0) }
    }
}

// 定义转换器
struct CodingKeysConverter {
    let mapping: [String: String]

    func callAsFunction(_ codingPath: [CodingKey]) -> CodingKey {
        guard let lastCoding = codingPath.last else { return SmartCodingKey.super }
        let stringKeys = codingPath.map { $0.stringValue }
        for (key, value) in mapping {
            if stringKeys.contains(key) {
                return SmartCodingKey(stringValue: value, intValue: nil)
            }
        }
        return lastCoding
    }
}

struct CodingKeysExactConverter {
    let mapping: [String: String]

    /// 在 Swift 中，callAsFunction 是一个特殊的方法，它允许你将一个类型实例当作函数来调用。
    func callAsFunction(_ codingPath: [CodingKey]) -> CodingKey {
        guard let lastCoding = codingPath.last else { return SmartCodingKey.super }
        let pathString = codingPath.toPathString()
        if let newKey = mapping[pathString] {
            return SmartCodingKey(stringValue: newKey, intValue: nil)
        }
        return lastCoding
    }
}


extension Array where Element == CodingKey {
    func toPathString() -> String {
        self.filter { !$0.stringValue.starts(with: "super") && !$0.stringValue.starts(with: "Index ") }
            .map { $0.stringValue }
            .joined(separator: ".")
    }
}


extension Sequence where Element: Hashable {
    fileprivate func _contains(_ elements: [Element]) -> Bool {
        return Set(elements).isSubset(of:Set(self))
    }
}


struct SmartCodingKey: CodingKey {
    
    public var stringValue: String
    
    public var intValue: Int?
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
    
    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
    
    static let `super` = SmartCodingKey(stringValue: "super")!
}
