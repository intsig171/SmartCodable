//
//  LogSnapshot.swift
//  SmartCodable
//
//  Created by Mccc on 2024/4/26.
//




import Foundation

/// Represents a container of related log entries with common coding path
struct LogContainer {
    
    /// 当前容器的类型（如果是unkeyed，就是Index+X。如果是keyed，就是Model的名称）
    var typeName: String
    
    /// 容器的路径
    var codingPath: [CodingKey] = []
    var path: String {
        let arr = codingPath.map {
            if let index = $0.intValue {
                return "Index \(index)"
            } else {
                return $0.stringValue
            }
        }
        return arr.joined(separator: "/")
    }
    
    // 当前容器下，解析错误的属性日志
    var logs: [LogItem] = []
    
    /// 用来从属哪次解析，以便做聚合
    var parsingMark: String
    
    
    var isUnKeyed: Bool {
        codingPath.last?.intValue != nil
    }
    var formatTypeName: String {
        isUnKeyed ? "[\(typeName)]" : typeName

    }
    
    /** pay attention to it
     1. 每一条path都是完整的解析路径。
     2. 路径中的每一个点都是container（keyed or unkeyed）。
     3. 这是当前container的logs。
     4. container信息包含两部分，
       - 4.1 如何体现容器本身的信息。
       - 4.2 如何体现容器中属性的信息。
     5. 根据path的层级控制tabs（空格）的多少，做到格式化。
     */
    func formatMessage(previousPath: String) -> String {
        var message = ""
        let components = comparePaths(previousPath: previousPath, currentPath: path)
        let commons = components.commons
        let differents = components.differents
        
        // 即将要显示的container距离左侧的距离
        let currentTabs = String(repeating: SmartSentinel.space, count: commons.count + 1)
        
        // 容器的信息
        for (index, item) in differents.enumerated() {
            
            let typeName = item.hasPrefix("Index ") ? "" : ": \(formatTypeName)"
            
            let sign = isUnKeyed ? SmartSentinel.unKeyContainerSign : SmartSentinel.keyContainerSign
            let containerInfo = "\(sign)\(item)\(typeName)\n"
            let tabs = currentTabs + String(repeating: SmartSentinel.space, count: index)
            message += "\(tabs)\(containerInfo)"
        }
        
        // 属性信息
        let fieldTabs = currentTabs + String(repeating: SmartSentinel.space, count: differents.count)
        for log in logs {
            message += "\(fieldTabs)\(SmartSentinel.attributeSign)\(log.formartMessage)"
        }
        
        return message
    }
    
    private func comparePaths(previousPath: String, currentPath: String) -> (commons: [String], differents: [String]) {
        
        // 将路径按照斜杠分割为路径点（整体处理空格）
        let previousComponents = previousPath.split(separator: "/")
        let currentComponents = currentPath.split(separator: "/")
        
        // 用于存储相同路径点
        var commonComponents: [String] = []
        // 找到相同路径点
        for (prev, curr) in zip(previousComponents, currentComponents) {
            if prev == curr {
                commonComponents.append(String(prev))
            } else {
                break
            }
        }
        let differentComponents = currentComponents.dropFirst(commonComponents.count).map { String($0) }
        return (commonComponents, differentComponents)
    }
}
