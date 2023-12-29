//
//  ToJSON.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/23
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

public extension Encodable {
    
    @inline(__always)
    func toJSON(using encoder: JSONEncoder = .init()) throws -> Data {
        return try encoder.encode(self)
    }
    
    @inline(__always)
    func toJSONString(using encoder: JSONEncoder = .init()) -> String? {
        guard let data = try? toJSON(using: encoder) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}
