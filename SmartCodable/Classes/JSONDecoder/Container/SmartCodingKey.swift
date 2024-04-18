// 
//  SmartCodingKey.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation

struct SmartCodingKey : CodingKey {
    
    public var stringValue: String
    
    public var intValue: Int?
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
    
    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
    
    static let `super` = SmartCodingKey(stringValue: "super")!
}
