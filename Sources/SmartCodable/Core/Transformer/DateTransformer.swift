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
    
    
    private var strategy: SmartDate.DateStrategy
    
    
    public init(strategy: SmartDate.DateStrategy) {
        self.strategy = strategy
    }
    
    public func transformFromJSON(_ value: Any) -> Date? {
        
        guard let (date, _) = DateParser.parse(value) else { return nil }
        return date
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
}
