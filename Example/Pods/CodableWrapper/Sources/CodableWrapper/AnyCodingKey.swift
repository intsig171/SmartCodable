//
//  AnyCodingKey.swift
//  CodableWrapper
//
//  Created by winddpan on 2020/8/15.
//

import Foundation

public struct AnyCodingKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?

    public init?(stringValue: String) {
        self.stringValue = stringValue
        intValue = nil
    }

    public init?(intValue: Int) {
        stringValue = "\(intValue)"
        self.intValue = intValue
    }

    public init(index: Int) {
        stringValue = "\(index)"
        intValue = index
    }
}
