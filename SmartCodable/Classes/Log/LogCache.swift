//
//  LogCache.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/23.
//

import Foundation

struct LogCache {
    private var snapshotDict = ThreadSafeDictionary<String, LogContainer>()
    
    mutating func save(error: DecodingError, className: String, decoder: String) {
        let log = LogItem.make(with: error)
        cacheLog(log, className: className, decoder: decoder)
    }
    
    mutating func clearCache(decoder: String) {
        snapshotDict.removeValue(forKey: decoder)
    }
    
    mutating func formatLogs(decoder: String) -> String? {
        
        
        filterLogItem()
        
        alignTypeNamesInAllSnapshots(decoder: decoder)
        
        let keyOrder = processArray(snapshotDict.getAllKeys(), decoder: decoder)
        
        
        let arr = keyOrder.compactMap {
            let container = snapshotDict.getValue(forKey: $0)
            return container?.formatMessage()
        }
        
        return arr.joined()
    }
}

extension LogCache {
    
    mutating func processArray(_ array: [String], decoder: String) -> [String] {
        
        var mutableArray = array.filter {
            $0.starts(with: decoder)
        }
        
        guard !mutableArray.isEmpty else { return [] }
        
        
        var indexToInsert: [(index: Int, element: String)] = []
        
        // 特别处理数组的第一个元素
        if let firstElement = mutableArray.first {
            let components = firstElement.components(separatedBy: "-")
            if components.count >= 3,
               components.last!.hasPrefix("Index "),
               !components[components.count - 2].hasPrefix("Index "),
               !components[components.count - 3].hasPrefix("Index ") {
                let newElement = components.dropLast(2).joined(separator: "-")
                mutableArray.insert(newElement, at: 0)
                
                if let snap = snapshotDict.getValue(forKey: firstElement) {
                    let container = LogContainer(typeName: "", logs: [], decoder: snap.decoder, codingPath: snap.codingPath.dropLast(2))
                    snapshotDict.setValue(container, forKey: newElement)
                }
            }
        }
        
        // 处理数组的其余元素
        for i in 1..<mutableArray.count {
            let currentComponents = mutableArray[i].components(separatedBy: "-")
            if currentComponents.count >= 3 {
                let lastKey = currentComponents.last!
                let secondLastKey = currentComponents[currentComponents.count - 2]
                let thirdLastKey = currentComponents[currentComponents.count - 3]
                
                if lastKey.hasPrefix("Index "), !secondLastKey.hasPrefix("Index "), !thirdLastKey.hasPrefix("Index ") {
                    let newElement = currentComponents.dropLast(2).joined(separator: "-")
                    let previousElement = mutableArray[i - 1]
                    
                    if newElement != previousElement {
                        indexToInsert.append((i, newElement))
                    }
                }
            }
        }
        
        // 插入新元素
        for insertion in indexToInsert.reversed() {
            mutableArray.insert(insertion.element, at: insertion.index)
        }
        
        return mutableArray
    }
    
    mutating func filterLogItem() {
        // 使用正则表达式匹配 keys
        let pattern = "Index \\d+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        var matchedKeys = snapshotDict.getAllKeys().filter { key in
            let range = NSRange(key.startIndex..<key.endIndex, in: key)
            return regex.firstMatch(in: key, options: [], range: range) != nil
        }
        
        matchedKeys = matchedKeys.sorted(by: < )
        
        var allLogs: [LogItem] = []
        
        let tempDict = snapshotDict
        for key in matchedKeys {
            var lessLogs: [LogItem] = []
            if var snap = snapshotDict.getValue(forKey: key) {
                let logs = snap.logs
                for log in logs {
                    if !allLogs.contains(where: { $0 == log }) {
                        lessLogs.append(log)
                        allLogs.append(log)
                    }
                }
                
                if lessLogs.isEmpty {
                    tempDict.removeValue(forKey: key)
                } else {
                    snap.logs = lessLogs
                    tempDict.setValue(snap, forKey: key)
                }
            }
        }
        snapshotDict = tempDict
    }
    
    private mutating func cacheLog(_ log: LogItem?, className: String, decoder: String) {
        
        guard let log = log else { return }
        
        let path = log.codingPath
        let key = createKey(path: path, decoder: decoder)
        
        // 如果存在相同的typeName和path，则合并logs
        if var existingSnapshot = snapshotDict.getValue(forKey: key) {
            
            if !existingSnapshot.logs.contains(where: { $0 == log }) {
                existingSnapshot.logs.append(log)
                snapshotDict.setValue(existingSnapshot, forKey: key)
                
            }
        } else {
            // 创建新的snapshot并添加到字典中
            let newSnapshot = LogContainer(typeName: className, logs: [log], decoder: decoder, codingPath: path)
            snapshotDict.setValue(newSnapshot, forKey: key)
        }
    }
    
    private func createKey(path: [CodingKey], decoder: String) -> String {
        let arr = path.map { $0.stringValue }
        return decoder + "\(arr.joined(separator: "-"))"
    }
    
    private mutating func alignTypeNamesInAllSnapshots(decoder: String) {
        snapshotDict.updateEach { key, snapshot in
            
            let maxLength = snapshot.logs.max(by: { $0.fieldName.count < $1.fieldName.count })?.fieldName.count ?? 0
            snapshot.logs = snapshot.logs.map { log in
                var modifiedLog = log
                modifiedLog.fieldName = modifiedLog.fieldName.padding(toLength: maxLength, withPad: " ", startingAt: 0)
                return modifiedLog
            }
        }
    }
}




class ThreadSafeDictionary<Key: Hashable, Value> {
    private var dictionary: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.example.ThreadSafeDictionary", attributes: .concurrent)
    
    
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
