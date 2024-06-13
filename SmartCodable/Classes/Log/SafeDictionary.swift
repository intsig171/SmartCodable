//
//  SafeDictionary.swift
//  SmartCodable
//
//  Created by qixin on 2024/6/5.
//

import Foundation


class SafeDictionary<Key: Hashable, Value> {
    
    private var dictionary: [Key: Value] = [:]
    
    private let queue = DispatchQueue(label: "com.Smart.ThreadSafe", attributes: .concurrent)
    
    
    func getValue(forKey key: Key) -> Value? {
        return queue.sync {
            return dictionary[key]
        }
    }
    
    func setValue(_ value: Value, forKey key: Key) {
        queue.async(flags: .barrier) { [weak self] in
            self?.dictionary[key] = value
        }
    }
    
    func removeValue(forKey key: Key) {
        queue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
        }
    }
    
    func removeAll() {
        queue.async(flags: .barrier) {
            self.dictionary.removeAll()
        }
    }
    
    func getAllValues() -> [Value] {
        return queue.sync {
            return Array(dictionary.values)
        }
    }
    
    func getAllKeys() -> [Key] {
        return queue.sync {
            return Array(dictionary.keys)
        }
    }
    
    func updateEach(_ body: (Key, inout Value) throws -> Void) rethrows {
        try queue.sync {
            var updatedDictionary: [Key: Value] = [:]
            for (key, var value) in dictionary {
                try body(key, &value)
                updatedDictionary[key] = value
            }
            queue.async(flags: .barrier) {
                self.dictionary = updatedDictionary
            }
        }
    }
}
