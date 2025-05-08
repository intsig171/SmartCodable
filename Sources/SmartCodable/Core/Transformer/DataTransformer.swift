//
//  SmartDataTransformer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/4/29.
//

import Foundation
public struct SmartDataTransformer: ValueTransformable {
    
    public typealias JSON = String
    public typealias Object = Data
    
    public init() {}
    
    public func transformFromJSON(_ value: Any) -> Data? {
        guard let string = value as? String else {
            return nil
        }
        return Data(base64Encoded: string)
    }

    public func transformToJSON(_ value: Data) -> String? {
        return value.base64EncodedString()
    }
}
