//
//  SmartLog.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/7.
//

import Foundation

public struct SmartConfig {
    
    public enum DebugMode: Int {
        case verbose = 0
        case debug = 1
        case error = 2
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
    
    
    /// Whether to enable assertions (effective in debug mode)
    /// Once enabled, an assertion will be performed where parsing fails, providing a more direct reminder to the user that parsing has failed at this point.
    public static var openErrorAssert: Bool = false
}


struct SmartLog {
    /// Occurs when an error is encountered, such as in a do-catch, with values outside normal expectations.
    static func logError(_ error: Error, className: String? = nil) {
        logIfNeeded(level: .error) {
            guard let info = resolveError(error, className: className) else { return nil }
            if SmartConfig.openErrorAssert {
                assert(false, info.message)
            }
            return info.message
        }
    }
    
    static func logDebug(_ error: Error, className: String? = nil) {
        logIfNeeded(level: .debug) {
            guard let info = resolveError(error, className: className) else { return nil }
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
                // Indicates an error in which the key cannot be found. This error is raised when the decoder expects to find a key in JSON but cannot find the key in the given data.
                // Usually occurs when the decoder attempts to extract the specified key-value pair from JSON but is unsuccessful
            case .keyNotFound(let key, let context):
                return ErrorInfo(type: "Key not found",
                                 location: className,
                                 fieldName: key.stringValue,
                                 codingPath: context.codingPath,
                                 reason: context.debugDescription)
                
                // Indicates an error where a value cannot be found. This error is raised when the decoder expects to extract a value from JSON, but the value does not exist.
                // This usually happens when the decoder tries to extract an optional value from JSON, but actually gets a null value.
            case .valueNotFound(let type, let context):
                return ErrorInfo(type: "Value is null",
                                 location: className,
                                 fieldName: context.codingPath.last?.stringValue ?? "",
                                 fieldType: "\(type)",
                                 codingPath: context.codingPath,
                                 reason: context.debugDescription)
                
                // Indicates a type mismatch error. This error is raised when the decoder expects the JSON value to be decoded to a specific type, but the type of the actual value does not match the expected type.
                // For example, the decoder expects an integer but actually gets a string
            case .typeMismatch(let type, let context):
                return ErrorInfo(type: "type mismatch",
                                 location: className,
                                 fieldName: context.codingPath.last?.stringValue ?? "",
                                 fieldType: "\(type)",
                                 codingPath: context.codingPath,
                                 reason: context.debugDescription)
                
                // An error indicating data corruption. This error is raised when the decoder cannot extract the required value from the given data.
                // Usually occurs when the data type does not match or the data structure is incorrect.
            case .dataCorrupted(let context):
                return ErrorInfo(type: "data corrupted",
                                 location: className,
                                 fieldName: context.codingPath.last?.stringValue ?? "",
                                 codingPath: context.codingPath,
                                 reason: context.debugDescription)
            default:
                break
            }
        }
        
        return ErrorInfo(type: "Unknown parsing error", reason: "\(error)")
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
            parts.append("ErrorType: \(type)")
        }
        
        if let location = location, !location.isEmpty {
            parts.append("ModelName：\(location)")
        }
                
        if let fieldName = fieldName {
            var fieldInfo = fieldName
            if let fieldType = fieldType, !fieldType.isEmpty {
                fieldInfo += " | Type is \(fieldType)"
            }
            parts.append("AttributeInfo：\(fieldInfo)")
        }
        
        if let paths = codingPath, paths.count > 1 {
            let pathInfo = paths.map { $0.stringValue }.joined(separator: " → ")
            parts.append("DecodingPath：" + pathInfo)
        }
        
        if let reason = reason, !reason.isEmpty {
            parts.append("ErrorReason: \(reason)")
        }
                
        return parts.joined(separator: "\n")
    }
}
