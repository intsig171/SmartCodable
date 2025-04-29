//
//  SmartHexColor.swift
//  SmartCodable
//
//  Created by dadadongl on 2025/4/22.
//

/**
 * A property wrapper that enables UIColor/NSColor handling in Codable properties by decoding hex strings.
 *
 * Supported hex string formats:
   - RGB, RGBA, RRGGBB, RRGGBBAA
   - #RGB, #RGBA, #RRGGBB, #RRGGBBAA
   - 0xRGB, 0xRGBA, 0xRRGGBB, 0xRRGGBBAA
   - 0XRGB, 0XRGBA, 0XRRGGBB, 0XRRGGBBAA
 *
 * Usage Example:
 *
 * ```
 struct SomeModel: SmartCodable {
     @SmartHexColor
     var titleColor: UIColor? = .white
     @SmartHexColor
     var descColor: UIColor?
 }
 * ```
 */

#if os(iOS) || os(tvOS) || os(watchOS)
public typealias ColorObject = UIColor
#elseif os(macOS)
public typealias ColorObject = NSColor
#else
public typealias ColorObject = UIColor // 根据 VisionKit 框架设置适当的颜色类型
#endif

public enum SmartColorHexFormat {
    // 常见
    case RGB
    case RGBA
    case RRGGBB
    case RRGGBBAA
    // 不常见
    case ARGB
    case AARRGGBB
}

@propertyWrapper
public struct SmartHexColor: Codable {
    public var wrappedValue: ColorObject?

    public init(wrappedValue: ColorObject?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)

        // 使用常见的格式解码 .RRGGBB, .RRGGBBAA, .RGB, .RGBA
        if let color = SmartColorHexFormat.color(from: hexString, with: [.RRGGBB, .RRGGBBAA, .RGB, .RGBA]) {
            self.wrappedValue = color
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot decode SmartHexColor from provided hex string. Only the following hex string formats are supported: RGB, RGBA, RRGGBB, RRGGBBAA, #RGB, #RGBA, #RRGGBB, #RRGGBBAA, 0xRGB, 0xRGBA, 0xRRGGBB, 0xRRGGBBAA, 0XRGB, 0XRGBA, 0XRRGGBB, 0XRRGGBBAA.")
        }
    }

    public func encode(to encoder: Encoder) throws {
        // 使用固定的格式编码 #RRGGBB
        if let value = wrappedValue, let hexString = SmartColorHexFormat.RRGGBB.string(from: value) {
            var container = encoder.singleValueContainer()
            try container.encode(hexString)
        }
    }
}

// MARK: internal

extension SmartColorHexFormat {
    static func hexValue(from string: String) -> (UInt64, String)? {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard string.count >= 3 else { return nil }

        let hexString: String

        if string.hasPrefix("#") {
            hexString = String(string[string.index(string.startIndex, offsetBy: 1) ..< string.endIndex])
        } else if string.hasPrefix("0x") {
            hexString = String(string[string.index(string.startIndex, offsetBy: 2) ..< string.endIndex])
        } else {
            hexString = string.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            if string.count == hexString.count {
                // 无前缀的Hex String
            } else {
                // 未知前缀 不支持
                return nil
            }
        }

        guard let hexValue = UInt64(hexString, radix: 16) else { return nil }
        return (hexValue, hexString)
    }

    static func color(from string: String, with formats: [SmartColorHexFormat]) -> ColorObject? {
        guard let hexInfo = hexValue(from: string) else {
            return nil
        }

        for format in formats {
            if let color = format.color(from: hexInfo.0, hexStringCount: hexInfo.1.count) {
                return color
            }
        }

        return nil
    }

    func color(from string: String) -> ColorObject? {
        guard let hexInfo = SmartColorHexFormat.hexValue(from: string) else {
            return nil
        }
        return color(from: hexInfo.0, hexStringCount: hexInfo.1.count)
    }

    func string(from color: ColorObject, prefix: String = "#") -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        guard color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
#else
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
#endif

        switch self {
        case .RGB:
            return String(format: "%@%1x%1x%1x", prefix, Int(red * 15), Int(green * 15), Int(blue * 15))
        case .RGBA:
            return String(format: "%@%1x%1x%1x%1x", prefix, Int(red * 15), Int(green * 15), Int(blue * 15), Int(alpha * 15))
        case .ARGB:
            return String(format: "%@%1x%1x%1x%1x", prefix, Int(alpha * 15), Int(red * 15), Int(green * 15), Int(blue * 15))
        case .RRGGBB:
            let rgb: Int = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
            return String(format: "%@%06x", prefix, rgb)
        case .RRGGBBAA:
            let rgba: Int = (Int(red * 255) << 24) | (Int(green * 255) << 16) | (Int(blue * 255) << 8) | Int(alpha * 255)
            return String(format: "%@%08x", prefix, rgba)
        case .AARRGGBB:
            let argb: Int = (Int(alpha * 255) << 24) | (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
            return String(format: "%@%08x", prefix, argb)
        }
    }

    func color(from hexValue: UInt64, hexStringCount: Int) -> ColorObject? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1 // 默认1

        switch self {
        case .RGB where hexStringCount == 3:
            red = CGFloat((hexValue & 0xF00) >> 8) / CGFloat(15)
            green = CGFloat((hexValue & 0xF0) >> 4) / CGFloat(15)
            blue = CGFloat(hexValue & 0xF) / CGFloat(15)

        case .RGBA where hexStringCount == 4:
            red = CGFloat((hexValue & 0xF000) >> 12) / CGFloat(15)
            green = CGFloat((hexValue & 0xF00) >> 8) / CGFloat(15)
            blue = CGFloat((hexValue & 0xF0) >> 4) / CGFloat(15)
            alpha = CGFloat(hexValue & 0xF) / CGFloat(15)

        case .ARGB where hexStringCount == 4:
            alpha = CGFloat((hexValue & 0xF000) >> 12) / CGFloat(15)
            red = CGFloat((hexValue & 0xF00) >> 8) / CGFloat(15)
            green = CGFloat((hexValue & 0xF0) >> 4) / CGFloat(15)
            blue = CGFloat(hexValue & 0xF) / CGFloat(15)

        case .RRGGBB where hexStringCount == 6:
            red = CGFloat((hexValue & 0xFF0000) >> 16) / CGFloat(255)
            green = CGFloat((hexValue & 0xFF00) >> 8) / CGFloat(255)
            blue = CGFloat(hexValue & 0xFF) / CGFloat(255)

        case .RRGGBBAA where hexStringCount == 8:
            red = CGFloat((hexValue & 0xFF000000) >> 24) / CGFloat(255)
            green = CGFloat((hexValue & 0xFF0000) >> 16) / CGFloat(255)
            blue = CGFloat((hexValue & 0xFF00) >> 8) / CGFloat(255)
            alpha = CGFloat(hexValue & 0xFF) / CGFloat(255)

        case .AARRGGBB where hexStringCount == 8:
            alpha = CGFloat((hexValue & 0xFF000000) >> 24) / CGFloat(255)
            red = CGFloat((hexValue & 0xFF0000) >> 16) / CGFloat(255)
            green = CGFloat((hexValue & 0xFF00) >> 8) / CGFloat(255)
            blue = CGFloat(hexValue & 0xFF) / CGFloat(255)

        default:
            return nil
        }

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
#else
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
#endif
    }
}
