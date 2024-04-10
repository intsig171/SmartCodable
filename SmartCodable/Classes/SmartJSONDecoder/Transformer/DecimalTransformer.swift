//
//  DecimalTransformer.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/9.
//

import Foundation
public struct SmartDecimalTransformer: ValueTransformable {
    
    public typealias JSON = String
    public typealias Object = NSDecimalNumber

    public init() { }
    
    
    public func transformFromJSON(_ value: Any?) -> NSDecimalNumber? {
        if let string = value as? String {
            return NSDecimalNumber(string: string)
        }
        if let double = value as? Double {
            return NSDecimalNumber(value: double)
        }
        return nil
    }

    public func transformToJSON(_ value: NSDecimalNumber?) -> String? {
        guard let value = value else { return nil }
        return value.description
    }
}
