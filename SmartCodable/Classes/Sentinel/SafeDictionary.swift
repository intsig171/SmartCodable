//
//  SafeDictionary.swift
//  SmartCodable
//
//  Created by Mccc on 2024/6/5.
//

import Foundation


class SafeDictionary<Key: Hashable, Value> {
    
    private var dictionary: [Key: Value] = [:]
    
    private let lock = NSLock()
    
    func getValue(forKey key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        return dictionary[key]
    }
    
    func setValue(_ value: Value, forKey key: Key) {
        lock.lock()
        defer { lock.unlock() }
        dictionary[key] = value
    }
    
    func removeValue(forKey key: Key) {
        lock.lock()
        defer { lock.unlock() }
        dictionary.removeValue(forKey: key)
    }
    
    /// 新增：按条件批量移除键值对
    func removeValue(where shouldRemove: (Key) -> Bool) {
        lock.lock()
        defer { lock.unlock() }
        dictionary = dictionary.filter { !shouldRemove($0.key) }
    }
    
    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        dictionary.removeAll()
    }
    
    func getAllValues() -> [Value] {
        lock.lock()
        defer { lock.unlock() }
        return Array(dictionary.values)
    }
    
    func getAllKeys() -> [Key] {
        lock.lock()
        defer { lock.unlock() }
        return Array(dictionary.keys)
    }
    
    func updateEach(_ body: (Key, inout Value) throws -> Void) rethrows {
        lock.lock()
        defer { lock.unlock() }
        var updatedDictionary: [Key: Value] = [:]
        for (key, var value) in dictionary {
            try body(key, &value)
            updatedDictionary[key] = value
        }
        dictionary = updatedDictionary
    }
}
