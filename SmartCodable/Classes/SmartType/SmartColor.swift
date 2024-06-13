//
//  SmartColor.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/22.
//

import Foundation



#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import Cocoa
#else
import VisionKit
#endif





#if os(iOS) || os(tvOS) || os(watchOS)
public typealias ColorObject = UIColor
#elseif os(macOS)
public typealias ColorObject = NSColor
#else
public typealias ColorObject = UIColor // 根据 VisionKit 框架设置适当的颜色类型
#endif

public enum SmartColor {
    case color(ColorObject)
    
    public init(from value: ColorObject) {
        self = .color(value)
    }
    
    public var peel: ColorObject {
        switch self {
        case .color(let c):
            return c
        }
    }
}


extension SmartColor: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        guard let color = ColorObject.hex(hexString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode SmartColor from provided hex string.")
        }
        self = .color(color)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .color(let color):
            try container.encode(color.hexString)
        }
    }
}
