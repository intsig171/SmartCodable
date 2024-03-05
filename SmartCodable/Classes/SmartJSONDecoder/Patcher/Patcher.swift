//
//  ValueCumulator.swift
//  SmartCodable
//
//  Created by Mccc on 2023/8/21.
//

import Foundation

/// 兼容器
struct Patcher<T: Decodable> {
    
    /// 提供当前类型的默认值
    static func defaultForType() throws -> T {
        return try Provider.defaultValue()
    }
    
    static func convertToType(from value: Any?) -> T? {
        return Transformer.typeTransform(from: value)
    }
    
    
    static func patchWithConvertOrDefault(value: Any?) -> T? {
        guard let value = value else { return nil }
        if let v = convertToType(from: value) { return v }
        if let v = try? defaultForType() { return v }
        return nil
    }
    
    static func getType(v: Any) -> String {
        return String(describing: type(of: v))
    }
}

