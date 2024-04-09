//
//  KeyTransformer.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/9.
//

import Foundation



public struct KeyTransformer: Transformable {
    
    public typealias From = [String]
    public typealias To = CodingKey

    var from: From
    var to: To
}


/// 映射关系
/// 将from对应的数据字段映射到to对应的模型属性上
/// 多个有效字段映射到同一个属性上优先使用第一个。

infix operator <---

public func <---(to: CodingKey, from: String) -> KeyTransformer {
    to <--- [from]
}
public func <---(to: CodingKey, from: [String]) -> KeyTransformer {
    KeyTransformer(from: from, to: to)
}
