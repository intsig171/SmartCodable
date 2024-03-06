// 
//  CodingKeysConverter.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2020/7/21
//  Copyright © 2020 Pircate. All rights reserved.
//

import Foundation

public typealias CodingPath = [String]

public extension JSONDecoder.KeyDecodingStrategy {
    
    static func mapper(_ container: [CodingPath: String]) -> JSONDecoder.KeyDecodingStrategy {
        .custom { CodingKeysConverter(container)($0) }
    }
}

struct CodingKeysConverter {
    let container: [CodingPath: String]
    
    init(_ container: [CodingPath: String]) {
        self.container = container
    }

    func callAsFunction(_ codingPath: [CodingKey]) -> CodingKey {
        guard !codingPath.isEmpty else { return CleanJSONKey.super }
        
        let stringKeys = codingPath.map { $0.stringValue }
        
        guard container.keys.contains(stringKeys) else { return codingPath.last! }
        
        return CleanJSONKey(stringValue: container[stringKeys]!, intValue: nil)
    }
}
