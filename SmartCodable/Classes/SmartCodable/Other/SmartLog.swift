//
//  SmartLog.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/7.
//

import Foundation

/// 日志的level控制
public struct SmartConfig {
    
    public enum DebugMode: Int {
        /// 详细日志
        case verbose = 0
        /// 调试日志
        case debug = 1
        /// 错误日志
        case error = 2
        /// 关闭日志
        case none = 3
    }
    
    private static var _mode = DebugMode.error
    public static var debugMode: DebugMode {
        get {
            return _mode
        }
        set {
            _mode = newValue
        }
    }
    
    /// 是否开启断言（debug模式有效）
    /// 开启之后，遇到解析失败的地方就会执行断言，更直接的提醒使用者这个地方解析失败了。
    public static var openErrorAssert: Bool = false
}


struct SmartLog {
    /// 发生错误的时候，比如do catch，  正常预期之外的值。
    static func logError(_ error: Error, className: String? = nil) {
        logIfNeeded(level: .error) {
            guard let info = resolveError(error, className: className) else { return nil }
            if SmartConfig.openErrorAssert {
                assert(false, info.message)
            }
            return info.message
        }
    }
    
    
    static func logDebug(_ item: String, className: String? = nil) {
        logIfNeeded(level: .debug) {
            let info = ErrorInfo(location: className, reason: item)
            return info.message
        }
    }
    
    static func logVerbose(_ item: String, className: String? = nil) {
        logIfNeeded(level: .verbose) {
            let info = ErrorInfo(location: className, reason: item)
            return info.message
        }
    }
    
    private static func logIfNeeded(level: SmartConfig.DebugMode, message: () -> String?) {
        
        func getHeader(level: SmartConfig.DebugMode) -> String {
            switch level {
            case .debug:
                return "\n============= 💚 [SmartLog Debug] 💚 =============\n"
            case .verbose:
                return "\n============= 💜 [SmartLog Verbose] 💜 =============\n"
            case .error:
                return "\n============= 💔 [SmartLog Error] 💔 =============\n"
            default:
                return ""
            }
        }
        
        func getFooter() -> String {
            return "\n==================================================\n"
        }
        
        
        if SmartConfig.debugMode.rawValue <= level.rawValue {
            if let output = message() {
                let header = getHeader(level: level)
                let footer = getFooter()
                print("\(header)\(output)\(footer)")
            }
        }
    }
}




extension SmartLog {
    fileprivate static func resolveError(_ error: Error, className: String?) -> ErrorInfo? {
        
        if let smartError = error as? SmartError {
            return ErrorInfo(type: smartError.reason,
                             location: className,
                             reason: smartError.description)
        }
        
        
        
        if let decodeError = error as? DecodingError {
            
            switch decodeError {
                // 表示找不到键的错误。当解码器期望在JSON中找到某个键，但在给定的数据中找不到该键时，会引发此错误。
                // 通常发生在解码器试图从JSON中提取指定的键值对但未成功时
            case .keyNotFound(let key, let context):
                return ErrorInfo(type: "找不到键的错误",
                                 location: className,
                                 fieldName: key.stringValue,
                                 codingPath: context.codingPath,
                                 reason: context.debugDescription)
                
                // 表示找不到值的错误。当解码器期望从JSON中提取某个值，但该值不存在时，会引发此错误。
                // 通常发生在解码器试图从JSON中提取一个可选值，但实际上得到了一个null值。
            case .valueNotFound(let type, let context):
                return ErrorInfo(type: "找不到值的错误",
                                 location: className,
                                 fieldName: context.codingPath.last?.stringValue ?? "",
                                 fieldType: "\(type)",
                                 codingPath: context.codingPath,
                                 reason: context.debugDescription)
                
                // 表示类型不匹配的错误。当解码器期望将JSON值解码为特定类型，但实际值的类型与期望的类型不匹配时，会引发此错误。
                // 例如，解码器期望一个整数，但实际上得到了一个字符串
            case .typeMismatch(let type, let context):
                return ErrorInfo(type: "值类型不匹配的错误",
                                 location: className,
                                 fieldName: context.codingPath.last?.stringValue ?? "",
                                 fieldType: "\(type)",
                                 codingPath: context.codingPath,
                                 reason: context.debugDescription)
                
                // 表示数据损坏的错误。当解码器无法从给定的数据中提取所需的值时，会引发此错误。
                // 通常发生在数据类型不匹配或数据结构不正确的情况下。
            case .dataCorrupted(let context):
                return ErrorInfo(type: "数据损坏的错误",
                                 location: className,
                                 fieldName: context.codingPath.last?.stringValue ?? "",
                                 codingPath: context.codingPath,
                                 reason: context.debugDescription)
            default:
                break
            }
        }
        
        return ErrorInfo(type: "未知的解析错误", reason: "\(error)")
    }
}



struct SmartError: Error {
    var reason: String
    var description: String
    
    init(reason: String, description: String) {
        self.reason = reason
        self.description = description
    }
}



fileprivate struct ErrorInfo {
    /// 错误类型
    private var type: String?
    /// 所在模型
    private var location: String?
    /// 字段名称
    private var fieldName: String?
    /// 字段类型
    private var fieldType: String?
    /// 字段路径
    private var codingPath: [CodingKey]?
    /// 错误原因
    private var reason: String?
    
    init(type: String? = nil,
         location: String? = nil,
         fieldName: String? = nil,
         fieldType: String? = nil,
         codingPath: [CodingKey]? = nil,
         reason: String? = nil) {
        self.type = type
        self.location = location
        self.fieldName = fieldName
        self.fieldType = fieldType
        self.codingPath = codingPath
        self.reason = reason
    }
    
    var message: String {
        
        var parts: [String] = []
        
        if let type = type, !type.isEmpty {
            parts.append("错误类型: '\(type)'")
        }
        
        if let location = location, !location.isEmpty {
            parts.append("模型名称：\(location)")
        }
        
        if let paths = codingPath, !paths.isEmpty {
            let pathInfo = paths.map { $0.stringValue }.joined(separator: " → ")
            parts.append("数据节点：" + pathInfo)
        } else if let fieldName = fieldName {
            parts.append("数据节点：" + fieldName)
        }
        
        if let fieldName = fieldName {
            var fieldInfo = fieldName
            if let fieldType = fieldType, !fieldType.isEmpty {
                fieldInfo += " | 类型\(fieldType)"
            }
            parts.append("属性信息：\(fieldInfo)")
        }
        
        if let reason = reason, !reason.isEmpty {
            parts.append("错误原因: \(reason)")
        }
                
        return parts.joined(separator: "\n")
    }
}
