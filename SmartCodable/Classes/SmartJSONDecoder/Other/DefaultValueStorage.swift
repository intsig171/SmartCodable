//
//  DefaultValueStorage.swift
//  SmartCodable
//
//  Created by qixin on 2024/3/5.
//

import Foundation



struct DefaultValueStorage {
    
    init() {}

    
    /// 当前的解码路径
    private(set) var codingPath: [CodingKey] = []
        
    /// 当前解码路径下的Model属性键值对
    private(set) var containers: [String: Any] = [:]
    
    /// 记录当前解码路径下Model属性以及对应值
    mutating func push<T: Decodable>(type: T.Type, codingPath: [CodingKey]) {
        
        if let object = T.self as? SmartDecodable.Type {
            let v1 = object.init()
            
            var decodablePaths: [String: Any] {
                
                var dict: [String: Any] = [:]
                
                let mirror = Mirror(reflecting: v1)
                for (key, value) in mirror.children {
                    if let key = key {
                        dict.updateValue(value, forKey: key)
                    }
                }
                return dict
            }
            containers = decodablePaths
            self.codingPath = codingPath
        }
        
    }
    
    func getValue<T: Decodable>(key: CodingKey, at path: [CodingKey]) -> T? {

        guard areCodingKeysEqual(codingPath, path) else { return nil }
        
        guard let value = containers[key.stringValue] else { return nil }
                
        guard let temp = value as? T else { return nil }
        
        return temp
    }
    
    mutating func clean<T: Decodable>(type: T.Type) {
        
        // 如果当前解码的类型不是继承SmartDecodable的Model，就不用处理
        // 正在解码model中的属性时，不能清空。解码完成才可以清空。
        if let _ = T.self as? SmartDecodable.Type {
            self.codingPath = []
            self.containers.removeAll()
        }
    }
}


fileprivate func areCodingKeysEqual(_ keys1: [CodingKey], _ keys2: [CodingKey]) -> Bool {
    // 如果数组长度不同，那么它们一定不相等
    if keys1.count != keys2.count { return false }

    // 比较每一对键，如果找到不匹配的，返回true
    for (key1, key2) in zip(keys1, keys2) {
        if key1.stringValue != key2.stringValue { return false }
    }

    // 如果所有键都匹配，那么它们相等，函数返回false
    return true
}
