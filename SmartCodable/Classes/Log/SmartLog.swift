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
        case warning = 2
        case none = 3

    }
    
    /// Set debug mode
    public static var debugMode: DebugMode {
        get { return _mode }
        set { _mode = newValue }
    }
    
    /// Set up different levels of padding
    public static var space: String = "   "
    /// Set the markup for the model
    public static var modelSign: String = "|> "
    /// Sets the tag for the property
    public static var attributeSign: String = "|- "
    
    /// Whether to enable assertions (effective in debug mode)
    /// Once enabled, an assertion will be performed where parsing fails, providing a more direct reminder to the user that parsing has failed at this point.
    public static var openErrorAssert: Bool = false
    
    private static var _mode = DebugMode.warning
}


struct SmartLog {
    
    private static var cache = LogCache()
    
    static func logDebug(_ error: DecodingError, className: String) {
        logIfNeeded(level: .debug) {
            if SmartConfig.openErrorAssert {
                assert(false, "\(error)")
            }
            cache.save(error: error, className: className)
        }
    }
    
    static func logWarning(error: DecodingError, className: String) {
        logIfNeeded(level: .warning) {
            cache.save(error: error, className: className)
        }
    }
    
    static func logVerbose(_ item: String, in className: String) {
        logIfNeeded(level: .verbose) {
            let header = getHeader()
            let footer = getFooter()
            let output = "[\(className)] \(item)\n"
            print("\(header)\(output)\(footer)")
        }
    }
    
    static func printCacheLogs(in name: String) {
        
        guard isAllowCacheLog() else { return }
        
        if let format = cache.formatLogs() {
            var message: String = ""
            message += getHeader()
            message += name + " 👈🏻 👀\n"
            message += format
            message += getFooter()
            print(message)
        }
        
        cache.clearCache()
    }
    
    static func isAllowCacheLog() -> Bool {
        if SmartConfig.debugMode.rawValue >= SmartConfig.DebugMode.verbose.rawValue {
           return true
        }
        return false
    }
}


extension SmartLog {
    
    static func getHeader() -> String {
        return "\n========================  [Smart Decoding Log]  ========================\n"
    }
    
    static func getFooter() -> String {
        return "=========================================================================\n"
    }
    
    private static func logIfNeeded(level: SmartConfig.DebugMode, callback: () -> ()) {
        if SmartConfig.debugMode.rawValue <= level.rawValue {
           callback()
        }
    }
}
