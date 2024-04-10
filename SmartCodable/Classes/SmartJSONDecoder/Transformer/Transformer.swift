//
//  SmartKeyTransformer.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/9.
//

import Foundation


/// 解析key的映射
public struct SmartKeyTransformer {
    var from: [String]
    var to: CodingKey
}

infix operator <---
/// 映射关系
/// 将from对应的数据字段映射到to对应的模型属性上
public func <---(to: CodingKey, from: String) -> SmartKeyTransformer {
    to <--- [from]
}

/// 映射关系
/// 多个有效字段映射到同一个属性上优先使用第一个。
public func <---(to: CodingKey, from: [String]) -> SmartKeyTransformer {
    SmartKeyTransformer(from: from, to: to)
}




public struct SmartValueTransformer {
    var location: CodingKey
    var tranformer: any ValueTransformable
    public init(location: CodingKey, tranformer: any ValueTransformable) {
        self.location = location
        self.tranformer = tranformer
    }
}


public protocol ValueTransformable {
    associatedtype Object
    associatedtype JSON
    func transformFromJSON(_ value: Any?) -> Object?
    func transformToJSON(_ value: Object?) -> JSON?
}

public func <---(location: CodingKey, tranformer: any ValueTransformable) -> SmartValueTransformer {
    SmartValueTransformer.init(location: location, tranformer: tranformer)
}
