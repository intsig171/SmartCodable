# SmartCodable



## 解析流程



### 非可选属性

#### 1. 缺少key

try impl.unwrap(as: type)

try type.init(from: self)

func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable

let decoded: T = try forceDecode(forKey: key)

使用初始化值

### 可选属性

try impl.unwrap(as: type)

try type.init(from: self)

func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable

guard let value = try? getValue(forKey: key) else { return nil }

#### 缺少key





## 理解遵循Codable的类型的解析逻辑

包含Int，Bool等，都是一样的逻辑。

```
extension SmartColor: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        guard let color = ColorObject.hex(hexString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode Color from provided hex string.")
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
```

在进行属性解析时候，会先进入

```
extension JSONDecoderImpl {
    // MARK: Special case handling

    func unwrap<T: Decodable>(as type: T.Type) throws -> T {
        if type == Date.self {
            return try self.unwrapDate() as! T
        }
        if type == Data.self {
            return try self.unwrapData() as! T
        }
        if type == URL.self {
            return try self.unwrapURL() as! T
        }
        if type == Decimal.self {
            return try self.unwrapDecimal() as! T
        }
        
        // 如果解析的是SmartColor类型属性，此处没有处理，就会进入SmartColor的init(decoder:)方法中。
        if type == SmartColor.self {
            return try self.unwrapSmartColor() as! T
        }
        
        if type is _JSONStringDictionaryDecodableMarker.Type {
            return try self.unwrapDictionary(as: type)
        }

        cache.cacheInitialState(for: type)
        let decoded = try type.init(from: self)
        cache.clearLastState(for: type)
        return decoded
    }

```

如果此处没有特殊处理

```
if type == SmartColor.self {
            return try self.unwrapSmartColor() as! T
}
```

就会执行`let decoded = try type.init(from: self)` .  系统会自动调度到`init（decoder）` 方法中。 
