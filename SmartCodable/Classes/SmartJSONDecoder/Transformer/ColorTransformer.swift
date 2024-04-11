//
//  ColorTransformer.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/9.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#else
import Cocoa
#endif
import UIKit


public enum SmartColor {
    case color(UIColor)
    
    public init(from value: UIColor) {
        self = .color(value)
    }
    
    public var peel: UIColor {
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
        guard let color = UIColor.hex(hexString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode UIColor from provided hex string.")
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



public struct SmartHexColorTransformer: ValueTransformable {

    #if os(iOS) || os(tvOS) || os(watchOS)
    public typealias Object = UIColor
    #else
    public typealias Object = NSColor
    #endif
    public typealias JSON = String

    public init() { }

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let rgba = value as? String {
            return UIColor.hex(rgba)
        }
        return nil
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        if let value = value {
            return value.hexString
        }
        return nil
    }
}


extension UIColor {
    
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
        return String(format:"#%06x", rgb)
    }
    
    static func hex(_ hex: String) -> UIColor? {
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        
        var useAlpha: CGFloat = 1


        
        var hex:   String = hex
        
        /** 开头是用0x开始的 */
        if hex.hasPrefix("0X") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }
        
        /** 开头是以＃＃开始的 */
        if hex.hasPrefix("##") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }
        
        /** 开头是以＃开头的 */
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                let index = hex.index(hex.startIndex, offsetBy: 1)
                
                /// 处理透明度
                let alphaStr = String(hex[hex.startIndex..<index])
                if let doubleValue = Double(alphaStr) {
                    useAlpha = CGFloat(doubleValue) / 15
                }
                
                hex = String(hex[index...])
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                let index = hex.index(hex.startIndex, offsetBy: 2)
                /// 处理透明度
                let alphaStr = String(hex[hex.startIndex..<index])
                if let doubleValue = Double(alphaStr) {
                    useAlpha = CGFloat(doubleValue) / 255
                }
                
                hex = String(hex[index...])
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                

            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                return nil
            }
        } else {
            return nil
        }
        return UIColor(red: red, green: green, blue: blue, alpha: useAlpha)
    }
}
