//
//  DateTransformer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/4/9.
//

import Foundation



public struct SmartDateTransformer: ValueTransformable {
    
    public typealias JSON =  Any
    public typealias Object = Date
    
    
    public enum Strategy {
        case timestamp                  // seconds
        case timestampMilliseconds      // milliseconds
        case iso8601
        case formatted(DateFormatter)   // custom date format
    }
    
    private var strategy: Strategy
    
    
    public init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    public func transformFromJSON(_ value: Any) -> Date? {
        
        switch strategy {
        case .timestamp:
            return parseTimestamp(from: value, isMilliseconds: false)
        case .timestampMilliseconds:
            return parseTimestamp(from: value, isMilliseconds: true)
        case .formatted(let formatter):
            return parseFormatted(from: value, formatter: formatter)
        case .iso8601:
            return parseISO8601(from: value)
        }
    }
    
    public func transformToJSON(_ value: Date) -> Any? {
        
        switch strategy {
        case .timestamp:
            return value.timeIntervalSince1970
        case .timestampMilliseconds:
            return value.timeIntervalSince1970 * 1000.0
        case .formatted(let formatter):
            return formatter.string(from: value)
        case .iso8601:
            let formatter = ISO8601DateFormatter()
            return formatter.string(from: value)
        }
    }
    
    private func parseTimestamp(from value: Any, isMilliseconds: Bool) -> Date? {
        if let double = value as? Double {
            return Date(timeIntervalSince1970: isMilliseconds ? double / 1000 : double)
        }
        if let string = value as? String, let double = Double(string) {
            return Date(timeIntervalSince1970: isMilliseconds ? double / 1000 : double)
        }
        return nil
    }
    
    private func parseFormatted(from value: Any, formatter: DateFormatter) -> Date? {
        if let string = value as? String {
            return formatter.date(from: string)
        }
        return nil
    }
    
    private func parseISO8601(from value: Any) -> Date? {
        if let string = value as? String {
            let isoFormatter = ISO8601DateFormatter()
            if let date = isoFormatter.date(from: string) {
                return date
            }
        }
        return nil
    }
}
