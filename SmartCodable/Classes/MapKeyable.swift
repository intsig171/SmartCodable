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



public extension JSONDecoder.KeyDecodingStrategy {
    
    /// 字段名称映射 ⚠️会对当前所有满足条件的字段进行映射转化。
    /// - Parameter container: 映射关系名，将json中的字段映射到模型的属性名上。
    ///   - String： json中的字段名
    ///   - String： 模型中的字段名称
    /// - Returns: 解析策略
    static func mapper(_ container: [String: String]) -> JSONDecoder.KeyDecodingStrategy {
        return .custom {
            CodingKeysConverter(container)($0)
        }
    }
}

struct CodingKeysConverter {
    let container: [String: String]
    
    init(_ container: [String: String]) {
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
        
        var targetMappingKey: String = ""
        for key in container.keys {
            if stringKeys.contains(key) {
                targetMappingKey = key
                break
            }
        }
        
        guard !targetMappingKey.isEmpty else { return codingPath.last! }

        if let value = container[targetMappingKey] {
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
