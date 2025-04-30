//
//  ColorTransformer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/4/9.
//

public struct SmartColorTransformer: ValueTransformable {
    public typealias Object = ColorObject

    public typealias JSON = String

    /// 预定义的转换器
    /// - Parameters:
    ///   - decodeFromHexFormat: 
    ///   - encodeToHexFormat:  o
    public init(decodeFromHexFormat: SmartColorHexFormat, encodeToHexFormat: SmartColorHexFormat = .RRGGBB) {
        self.decodeFormat = decodeFromHexFormat
        self.encodeFormat = encodeToHexFormat
        self.fromJSON = nil
        self.toJSON = nil
    }

    /// 自定义的转换器
    /// - Parameters:
    ///   - fromJSON: json 转 object
    ///   - toJSON:  object 转 json， 如果需要转json，可以不实现。
    public init(fromJSON: @escaping (JSON?) -> Object?, toJSON: ((Object?) -> JSON?)? = nil) {
        self.fromJSON = fromJSON
        self.toJSON = toJSON
        self.decodeFormat = nil
        self.encodeFormat = nil
    }

    public func transformFromJSON(_ value: Any) -> Object? {
        guard let rgba = value as? String else {
            return nil
        }
        if let fr = fromJSON {
            return fr(rgba)
        }
        if let decodeFormat = decodeFormat {
            return decodeFormat.color(from: rgba)
        }
        return nil
    }

    public func transformToJSON(_ value: Object) -> JSON? {
        if let to = toJSON {
            return to(value)
        }
        if let encodeFormat = encodeFormat {
            return encodeFormat.string(from: value)
        }
        return nil
    }

    // 预定于编解码格式
    private var decodeFormat: SmartColorHexFormat?
    private var encodeFormat: SmartColorHexFormat?

    // 自定义
    private var fromJSON: ((JSON?) -> Object?)?
    private var toJSON: ((Object?) -> JSON?)?
}
