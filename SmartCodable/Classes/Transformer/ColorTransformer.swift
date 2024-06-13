//
//  ColorTransformer.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/9.
//


#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import Cocoa
#else
import VisionKit
#endif


public struct SmartHexColorTransformer: ValueTransformable {

    public typealias Object = ColorObject
    
    public typealias JSON = String

    public init() { }

    public func transformFromJSON(_ value: Any) -> Object? {
        if let rgba = value as? String {
            return ColorObject.hex(rgba)
        }
        return nil
    }

    public func transformToJSON(_ value: Object) -> JSON? {
        return value.hexString
    }
}


extension ColorObject {
    
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
        return String(format:"#%06x", rgb)
    }
    
    static func hex(_ hex: String) -> ColorObject? {
        
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
        
#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        return UIColor(red: red, green: green, blue: blue, alpha: useAlpha)
#else
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: useAlpha)
#endif
    }
}
