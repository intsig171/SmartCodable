//
//  DateTransformer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/4/9.
//

import Foundation



/// Timestamp Date （timeIntervalSince1970）
public struct SmartDateTransformer: ValueTransformable {
    public typealias JSON = Double
    public typealias Object = Date
        
    private var _milliseconds: Bool

    
    public init(isMilliseconds: Bool = false) {
        _milliseconds = isMilliseconds
    }
    
    public func transformFromJSON(_ value: Any) -> Date? {
        
        if _milliseconds {
            if let timeInt = value as? Double {
                return Date(timeIntervalSince1970: timeInt / 1000.0)
            }
            
            if let timeStr = value as? String, let timeDouble = Double(timeStr) {
                return Date(timeIntervalSince1970: timeDouble / 1000.0)
            }
        } else {
            if let timeInt = value as? Double {
                return Date(timeIntervalSince1970: timeInt)
            }
            
            if let timeStr = value as? String, let timeDouble = Double(timeStr) {
                return Date(timeIntervalSince1970: timeDouble)
            }
        }
        
        return nil
    }
    
    public func transformToJSON(_ value: Date) -> Double? {
        let timeInterval = value.timeIntervalSince1970
        return _milliseconds ? timeInterval * 1000.0 : timeInterval
    }
}



/// DateFormat Date
public struct SmartDateFormatTransformer: ValueTransformable {
    public typealias JSON = String
    public typealias Object = Date
    
    let dateFormatter: DateFormatter

    public init(_ dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }

    public func transformFromJSON(_ value: Any) -> Date? {
        if let dateString = value as? String {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }

    public func transformToJSON(_ value: Date) -> String? {
        return dateFormatter.string(from: value)
    }
}
