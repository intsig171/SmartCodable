//
//  LogSnapshot.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/26.
//

import Foundation
struct LogContainer {
    
    /// 当前容器的类型，通过判断path的最后一个key，是Index么？ 判断是keyed还是unKeyed容器。
    var typeName: String
    
    
    // 当前容器下，解析错误的属性日志
    var logs: [LogItem] = []
    
    /// 用来从属哪次解析，以便做聚合
    var parsingMark: String

    /// 容器的路径
    var codingPath: [CodingKey] = []
    
    /// 需要格式化的路径
    var formatCodingPath: [CodingKey] {
        codingPath.filter({ $0.intValue == nil})
    }
    
    var isUnKeyed: Bool {
        codingPath.last?.intValue != nil
    }
    
    var containerTab: String {
        return String(repeating: SmartConfig.space, count: formatCodingPath.count)
    }
    
    var fieldTab: String {
        return containerTab + SmartConfig.space
    }
    
    var fildName: String {
        return codingPath.last?.stringValue ?? ""
    }
    
    var formatTypeName: String {
        isUnKeyed ? "[\(typeName)]" : typeName
    }
    
    func formatMessage() -> String {
        var message = ""
        let modelSign = SmartConfig.modelSign
        let attributeSign = SmartConfig.attributeSign
        
        // 处理最后一个元素
        if let last = formatCodingPath.last {
            // 容器的字段
            message += "\(containerTab)\(modelSign)"
            if let penultimate = codingPath.penultimate?.intValue {
                message += "[Index \(penultimate)] "
            } else {
                if let antepenultimate = codingPath.antepenultimate?.intValue {
                    message += "[Index \(antepenultimate)] "
                }
            }
            message += "\(last.stringValue): "
            
            // 容器的类型
            message += "\(formatTypeName)\n"
        }
        
        // 处理日志信息
        for log in logs {
            message += "\(fieldTab)\(attributeSign)"
            if let last = log.codingPath.last?.intValue {
                message += "[Index \(last)] "
            }
            message += "\(log.formartMessage)"
        }
        
        return message
    }
}

extension Array {
    /// 倒数第二个
    var penultimate: Element? {
        guard count >= 2 else { return nil }
        return self[count - 2]
    }
    
    /// 倒数第三个
    var antepenultimate: Element? {
        guard count >= 3 else { return nil }
        return self[count - 3]
    }
    
    func removeFromEnd(_ count: Int) -> [Element]? {
        guard count >= 0 else { return nil }
        let endIndex = self.count - count
        guard endIndex >= 0 else { return nil }
        return Array(self.prefix(endIndex))
    }
}
