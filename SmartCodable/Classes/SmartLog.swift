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
    public static var openErrorAssert: Bool = true
}


struct SmartLog {
    /// 发生错误的时候，比如do catch，  正常预期之外的值。
    static func logError(_ error: Error, className: String? = nil) {
        if SmartConfig.debugMode.rawValue <= SmartConfig.DebugMode.error.rawValue {
            guard let info = resolveError(error, className: className) else { return }
            if SmartConfig.openErrorAssert {
                assert(false, info.message)
            }
            print(info.message)
        }
    }
    
    static func logDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if SmartConfig.debugMode.rawValue <= SmartConfig.DebugMode.debug.rawValue {
            print(items, separator: separator, terminator: terminator)
        }
    }
    
    static func logVerbose(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if SmartConfig.debugMode.rawValue <= SmartConfig.DebugMode.verbose.rawValue {
            print(items, separator: separator, terminator: terminator)
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
    private var type: String
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
    
    init(type: String,
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
        
        var all: String = ""
        

        let one = "\n================ [SmartLog Error] ================\n"
        all += one
        
        let two = "错误类型: '\(type)' \n"
        all += two
        
        
        // 模型名称
        if let temp = location, temp.count > 0 {
            let string = "模型名称：\(temp) \n"
            all += string
        }
        
        
        // 数据节点
        if let paths = codingPath, !paths.isEmpty {
            var pathInfo: String = ""
            for (index, path) in paths.enumerated() {
                pathInfo += path.stringValue
                
                if index < (paths.count-1) {
                    pathInfo += " → "
                }
            }
            all += "数据节点：" + pathInfo + "\n"
        } else {
            if let temp = fieldName {
                all += "数据节点：" + temp + "\n"
            }
        }
        


        // 属性信息
        if let temp = fieldName {
            var fieldInfo: String = ""

            if let temp = fieldType {
                let string = "（类型）\(temp) "
                fieldInfo += string
            }
            
            let string = "（名称）\(temp)"
            fieldInfo += string
            all += "属性信息：" + fieldInfo + "\n"

        }

        
        if let temp = reason {
            let string = "错误原因: \(temp)\n"
            all += string
        }
        
        let six = "==================================================\n"
        all += six
        
        return all
    }
    
}
