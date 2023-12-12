


public typealias SmartCodable = SmartDecodable & SmartEncodable






/// [SmartCodable] 类型的数组支持解析。
extension Array: SmartCodable where Element: SmartCodable { }
