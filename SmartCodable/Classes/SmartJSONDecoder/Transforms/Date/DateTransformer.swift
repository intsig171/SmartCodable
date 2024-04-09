//
//  DateTransformer.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/9.
//

import Foundation

//struct DateTransformer: Transformable, ValueTransformable {
////    static func transformValue(from value: Any) -> DateTransformer? {
////
////    }
//    
//    typealias From = Any
//    typealias To = Date
//    
//    
//}


//open class DateTransformer: Transformable, ValueTransformer {
//    public typealias From = Double
//    public typealias To = Date
//
//
////    public init() {}
//
////    open func transformFromJSON(_ value: Any?) -> Date? {
////        if let timeInt = value as? Double {
////            return Date(timeIntervalSince1970: TimeInterval(timeInt))
////        }
////
////        if let timeStr = value as? String {
////            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
////        }
////
////        return nil
////    }
////
////    open func transformToJSON(_ value: Date?) -> Double? {
////        if let date = value {
////            return Double(date.timeIntervalSince1970)
////        }
////        return nil
////    }
//}
