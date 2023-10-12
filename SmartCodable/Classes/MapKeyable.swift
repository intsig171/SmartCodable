//
//  CodingKey.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/1.
//

import Foundation


// 模型字段名称映射
// decoder.keyDecodingStrategy = .mapper([
//      ["first_name"]: "firstName"
// ])


public typealias SmartMappingKey = String


public extension JSONDecoder.KeyDecodingStrategy {
    
    /// 模型字段名称映射
    /// - Parameter container: 要映射的项
    ///   - SmartMappingKeys： 原始字段名，可以支持多个
    ///   - String： 模型中的字段名称
    /// - Returns: 解析策略
    static func mapper(_ container: [[SmartMappingKey]: String]) -> JSONDecoder.KeyDecodingStrategy {
        .custom {
            CodingKeysConverter(container)($0)
        }
    }
    
    
    
    static func mapper(_ container: [SmartMappingKey: String]) -> JSONDecoder.KeyDecodingStrategy {
        var newContainer: [[SmartMappingKey]: String] = [:]
        for (key, value) in container {
            newContainer.updateValue(value, forKey: [key])
        }
        
        return .custom {
            CodingKeysConverter(newContainer)($0)
        }
    }
}

struct CodingKeysConverter {
    let container: [[SmartMappingKey]: String]
    
    init(_ container: [[SmartMappingKey]: String]) {
        self.container = container
    }

    // 在 Swift 中，callAsFunction 是一个特殊的方法，它允许你将一个类型实例当作函数来调用。通过在类型中实现 callAsFunction 方法，你可以像调用函数一样使用该类型的实例。
    func callAsFunction(_ codingPath: [CodingKey]) -> CodingKey {
        
        /** 各个值的理解
         *
         * codingPath: JSONKey结构，对应的是json中的字段名称
         * container: 传入的映射字典，[SmartMappingKeys: String]
         * stringKeys: 获取的json中的字段名称数组
         *
         */
        
        
        /** 映射值的取值逻辑 （倒推法）
         * 1. SmartJSONKey(stringValue: value, intValue: nil) 接收的值是，模型中对应的字段名。
         * 2. 该字段名是container的value。
         * 3. 所以要先确认container的value对应的key。
         * 4. 遍历container.keys，如果包含stringKeys，此时的key就是我们的目标。
         */
        
        guard !codingPath.isEmpty else { return SmartCodingKey.super }
        let stringKeys = codingPath.map { $0.stringValue }
        
        var targetMappingKeys: [SmartMappingKey] = []
        for keys in container.keys {
            if keys._contains(stringKeys) {
                targetMappingKeys = keys
                break
            }
        }
        
        guard !targetMappingKeys.isEmpty else { return codingPath.last! }
        
        if let value = container[targetMappingKeys] {
            return SmartCodingKey(stringValue: value, intValue: nil)
        } else {
            return codingPath.last!
        }
    }
}

extension Sequence where Element: Hashable {
    fileprivate func _contains(_ elements: [Element]) -> Bool {
        return Set(elements).isSubset(of:Set(self))
    }
}
