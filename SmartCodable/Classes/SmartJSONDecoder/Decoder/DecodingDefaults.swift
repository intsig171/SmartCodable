//
//  DecodingDefaults.swift
//  SmartCodable
//
//  Created by qixin on 2024/3/5.
//

import Foundation


/// 记录解码中模型属性的默认值, 用于解码失败的时候填充。
struct DecodingDefaults {
    
    private(set) var typeName: String = ""
    
    /// 当前的解码路径（通过解码路径确保对应关系）
    private var codingPath: [CodingKey] = []
        
    /// 记录模型属性的默认值
    private var containers: [String: Any] = [:]
    
    /// 记录type类型的属性初始化的值
    mutating func recordAttributeValues<T: Decodable>(for type: T.Type, codingPath: [CodingKey]) {
        // 直接使用反射初始化对象，如果T符合SmartDecodable协议
        if let object = type as? SmartDecodable.Type {
            let instance = object.init()            
            // 使用反射获取属性名称和值
            let mirror = Mirror(reflecting: instance)
            mirror.children.forEach { child in
                if let key = child.label {
                    containers[key] = child.value
                }
            }
            self.typeName = "\(type)"
            self.codingPath = codingPath
        }
    }
    
    func getValue<T: Decodable>(forKey key: CodingKey, atPath path: [CodingKey]) -> T? {
        guard areCodingKeysEqual(codingPath, path),
                let value = containers[key.stringValue] as? T else {
            return nil
        }
        return value
    }
    
    mutating func resetRecords<T: Decodable>(for type: T.Type) {
        
        // 如果当前解码的类型不是继承SmartDecodable的Model，就不用处理
        // 正在解码model中的属性时，不能清空。解码完成才可以清空。
        if let _ = T.self as? SmartDecodable.Type {
            self.typeName = ""
            self.codingPath = []
            self.containers.removeAll()
        }
    }
    
    private func areCodingKeysEqual(_ keys1: [CodingKey], _ keys2: [CodingKey]) -> Bool {
        return keys1.count == keys2.count && !zip(keys1, keys2).contains { $0.stringValue != $1.stringValue }
    }
}



