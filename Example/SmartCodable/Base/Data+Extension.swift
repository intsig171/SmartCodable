//
//  Data+Extension.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation


extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    func toDictionary() -> Dictionary<String, Any>? {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
                return dictionary
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func toArray() -> Array<Any>? {
        do {
            if let array = try JSONSerialization.jsonObject(with: self, options: []) as? [Any] {
                return array
            }
        } catch {
            return nil
        }
        return nil
    }
}
