//
//  LogCache.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/23.
//

import Foundation

struct LogCache {
    private var snapshotDict: [String: LogContainer] = [:]
    private var keyOrder: [String] = [] // 记录key的添加顺序
    
    mutating func save(error: DecodingError, className: String) {
        let log = LogItem.make(with: error)
        cacheLog(log, className: className)
    }

    mutating func clearCache() {
        snapshotDict.removeAll()
        keyOrder.removeAll()
    }
    
    mutating func formatLogs() -> String? {
        
        guard !snapshotDict.isEmpty else { return nil }
        guard !keyOrder.isEmpty else { return nil }

        filterLogItem()

        keyOrder = processArray(keyOrder)
        alignTypeNamesInAllSnapshots()
        return keyOrder.compactMap { snapshotDict[$0]?.formatMessage() }.joined()
    }
}

extension LogCache {
    
    mutating func processArray(_ array: [String]) -> [String] {
        var mutableArray = array
        var indexToInsert: [(index: Int, element: String)] = []
        
        func createLogContainer(path: [CodingKey]) -> LogContainer {
            let container = LogContainer(typeName: "", logs: [], codingPath: path)
            return container
        }

        // 特别处理数组的第一个元素
        if let firstElement = mutableArray.first {
            let components = firstElement.components(separatedBy: "-")
            if components.count >= 3,
               components.last!.hasPrefix("Index "),
               !components[components.count - 2].hasPrefix("Index "),
               !components[components.count - 3].hasPrefix("Index ") {
                let newElement = components.dropLast(2).joined(separator: "-")
                mutableArray.insert(newElement, at: 0)
 
                if let snap = snapshotDict[firstElement] {
                    let container = LogContainer(typeName: "", logs: [], codingPath: snap.codingPath.dropLast(2))
                    snapshotDict.updateValue(container, forKey: newElement)
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
        var matchedKeys = snapshotDict.keys.filter { key in
            let range = NSRange(key.startIndex..<key.endIndex, in: key)
            return regex.firstMatch(in: key, options: [], range: range) != nil
        }
        
        matchedKeys = matchedKeys.sorted(by: < )
        
        var allLogs: [LogItem] = []
        
        var tempDict = snapshotDict
        for key in matchedKeys {
            var lessLogs: [LogItem] = []
            if var snap = snapshotDict[key] {
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
                    tempDict.updateValue(snap, forKey: key)
                }
            }
        }
        snapshotDict = tempDict
    }
    
    private mutating func cacheLog(_ log: LogItem?, className: String) {
        
        guard let log = log else { return }
        
        let path = log.codingPath
        let key = createKey(path: path)
                
        // 如果存在相同的typeName和path，则合并logs
        if var existingSnapshot = snapshotDict[key] {
            
            if !existingSnapshot.logs.contains(where: { $0 == log }) {
                existingSnapshot.logs.append(log)
                snapshotDict[key] = existingSnapshot
            }
        } else {
            // 创建新的snapshot并添加到字典中
            let newSnapshot = LogContainer(typeName: className, logs: [log], codingPath: path)
            snapshotDict[key] = newSnapshot
            keyOrder.append(key) // 记录新添加的key
        }
    }
    
    private func createKey(path: [CodingKey]) -> String {
        let arr = path.map { $0.stringValue }
        return "\(arr.joined(separator: "-"))"
    }
    
    private mutating func alignTypeNamesInAllSnapshots() {
        for (key, var snapshot) in snapshotDict {
            let maxLength = snapshot.logs.max(by: { $0.fieldName.count < $1.fieldName.count })?.fieldName.count ?? 0
            snapshot.logs = snapshot.logs.map { log in
                var modifiedLog = log
                modifiedLog.fieldName = modifiedLog.fieldName.padding(toLength: maxLength, withPad: " ", startingAt: 0)
                return modifiedLog
            }
            snapshotDict[key] = snapshot
        }
    }
}




