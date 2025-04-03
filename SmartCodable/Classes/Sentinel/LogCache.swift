//
//  LogCache.swift
//  SmartCodable
//
//  Created by Mccc on 2024/4/23.
//

import Foundation

/**
 A logging system for tracking and reporting decoding errors in SmartCodable parsing.
 
 The system provides:
 - Hierarchical error logging with visual formatting
 - Configurable logging levels
 - Thread-safe logging operations
 - Customizable output handlers
 */
struct LogCache {
    
    private var snapshotDict = SafeDictionary<String, LogContainer>()
    
    /// Saves a decoding error to the log cache
    mutating func save(error: DecodingError, className: String, parsingMark: String) {
        let log = LogItem.make(with: error)
        cacheLog(log, className: className, parsingMark: parsingMark)
    }
    
    /// Clears cached logs for a specific parsing session
    mutating func clearCache(parsingMark: String) {
        snapshotDict.removeValue { $0.hasPrefix(parsingMark) }
    }
    
    /// Formats all logs for a parsing session into a readable string
    mutating func formatLogs(parsingMark: String) -> String? {
        
        filterLogItem()
        
        alignTypeNamesInAllSnapshots(parsingMark: parsingMark)
        
        let keyOrder = sortKeys(snapshotDict.getAllKeys(), parsingMark: parsingMark)
        
        var lastPath: String = ""
        let arr = keyOrder.compactMap {
            let container = snapshotDict.getValue(forKey: $0)
            let message = container?.formatMessage(previousPath: lastPath)
            lastPath = container?.path ?? ""
            return message
        }
        
        if arr.isEmpty { return nil }
        return arr.joined()
    }
}

extension LogCache {
    
    /// Sorts log keys for consistent output ordering
    func sortKeys(_ array: [String], parsingMark: String) -> [String] {
        //  获取当前解析的keys
        let filterArray = array.filter {
            $0.starts(with: parsingMark)
        }
        guard !filterArray.isEmpty else { return [] }
        
        let sortedArray = filterArray.sorted()
        return sortedArray
    }
    
    /// Filters duplicate log items across containers
    mutating func filterLogItem() {
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
    
    /// Caches an individual log item
    private mutating func cacheLog(_ log: LogItem?, className: String, parsingMark: String) {
        
        guard let log = log else { return }
        
        let path = log.codingPath
        let key = createKey(path: path, parsingMark: parsingMark)
        
        // 如果存在相同的typeName和path，则合并logs
        if var existingSnapshot = snapshotDict.getValue(forKey: key) {
            if !existingSnapshot.logs.contains(where: { $0 == log }) {
                existingSnapshot.logs.append(log)
                snapshotDict.setValue(existingSnapshot, forKey: key)
            }
        } else {
            // 创建新的snapshot并添加到字典中
            let newSnapshot = LogContainer(typeName: className, codingPath: path, logs: [log], parsingMark: parsingMark)
            snapshotDict.setValue(newSnapshot, forKey: key)
        }
    }
    
    /// Creates a unique key for a log entry
    private func createKey(path: [CodingKey], parsingMark: String) -> String {
        let arr = path.map { $0.stringValue }
        return parsingMark + "\(arr.joined(separator: "-"))"
    }
    
    /// Aligns field names for consistent visual output
    private mutating func alignTypeNamesInAllSnapshots(parsingMark: String) {
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




