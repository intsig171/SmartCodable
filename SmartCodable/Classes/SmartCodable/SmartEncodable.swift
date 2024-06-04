//
//  SmartEncodable.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/4.
//

import Foundation


public protocol SmartEncodable: Encodable {
    /// The callback for when mapping is complete
    mutating func didFinishMapping()
  
    /// The mapping relationship of decoding keys
    static func mappingForKey() -> [SmartKeyTransformer]?
    
    /// The strategy for decoding values
    static func mappingForValue() -> [SmartValueTransformer]?
    
    init()
}


extension SmartEncodable {

    public func toDictionary() -> [String: Any]? {
        return _transformToJson(self, type: Self.self)
    }
    
    
    /// Serializes into a JSON string
    /// - Parameter prettyPrint: Whether to format print (adds line breaks in the JSON)
    /// - Returns: JSON string
    public func toJSONString(prettyPrint: Bool = false) -> String? {
        
        // is dictionary
        if let jsonObject = self as? [String: Any] {
            return _transformToJsonString(object: jsonObject, prettyPrint: prettyPrint, type: Self.self)
        }
        
        // to dictionary
        if let anyObject = toDictionary() {
            return _transformToJsonString(object: anyObject, prettyPrint: prettyPrint, type: Self.self)
        }
        return nil
    }
    
}



extension Array where Element: SmartEncodable {
    public func toArray() -> [Any]? {
        return _transformToJson(self,type: Element.self)
    }
    
    /// Serializes into a JSON string
    /// - Parameter prettyPrint: Whether to format print (adds line breaks in the JSON)
    /// - Returns: JSON string
    public func toJSONString(prettyPrint: Bool = false) -> String? {
        if let anyObject = toArray() {
            return _transformToJsonString(object: anyObject, prettyPrint: prettyPrint, type: Element.self)
        }
        return nil
    }
}


fileprivate func _transformToJsonString(object: Any, prettyPrint: Bool = false, type: Any.Type) -> String? {
    if JSONSerialization.isValidJSONObject(object) {
        do {
            let options: JSONSerialization.WritingOptions = prettyPrint ? [.prettyPrinted] : []
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: options)
            return String(data: jsonData, encoding: .utf8)
            
        } catch {
            SmartLog.logVerbose("\(error)", in: "\(type)")
        }
    } else {
        SmartLog.logVerbose("\(object)) is not a valid JSON Object", in: "\(type)")
    }
    return nil
}


fileprivate func _transformToJson<T>(_ some: Encodable, type: Any.Type) -> T? {
    let jsonEncoder = SmartJSONEncoder()
    if let jsonData = try? jsonEncoder.encode(some) {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed)
            
            if let temp = json as? T {
                return temp
            } else {
                SmartLog.logVerbose("\(json)) is not a valid Type", in: "\(type)")
            }
        } catch {
            SmartLog.logVerbose("\(error)", in: "\(type)")
        }
    }
    return nil
}
