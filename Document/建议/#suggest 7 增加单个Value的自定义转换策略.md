# #suggest 7 增加单个Value的自定义转换策略



在苹果官方的Codable设计中，提供了四种策略用来做自定义转换。

```
    /// The strategy to use in decoding dates. Defaults to `.deferredToDate`.
    open var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy

    /// The strategy to use in decoding binary data. Defaults to `.base64`.
    open var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy

    /// The strategy to use in decoding non-conforming numbers. Defaults to `.throw`.
    open var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy

    /// The strategy to use for decoding keys. Defaults to `.useDefaultKeys`.
    open var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
```



我们来看一个使用例子：

```
struct Model: SmartCodable {
    var date: Date?
}

let json = """
{
   "date": "2024-04-07"
}
"""
guard let data = json.data(using: .utf8) else { return }
let decoder = JSONDecoder()
let df = DateFormatter()
df.dateFormat = "yyyy-MM-dd"
decoder.dateDecodingStrategy = .formatted(df)
let model = try? decoder.decode(Model.self, from: data)
print(model)
```

可以看到 `dateDecodingStrategy` 的作用域是针对当前的 `decoder`。



## SmartCodable的处理

```
public enum SmartDecodingOption: Hashable {
    
    case date(JSONDecoder.DateDecodingStrategy)
    
    case data(JSONDecoder.DataDecodingStrategy)
    
    case float(JSONDecoder.NonConformingFloatDecodingStrategy)
    
    /// The mapping strategy for keys during parsing
    case key(JSONDecoder.SmartKeyDecodingStrategy)
}
```

依托于系统 `Codable` 也实现了这个逻辑。

```
struct Model: SmartCodable {
    var date: Date?
    var date1: Date?
}

let dict1: [String: Any] = [
    "date": "2024-04-07",
    "date1": 1712491290,
]

let df = DateFormatter()
df.dateFormat = "yyyy-MM-dd"
let option: SmartDecodingOption = .date(.formatted(df))
guard let model = Model.deserialize(from: dict1, options: [option]) else { return }
print(model)
```

但是查看打印结果:

```
Model(date: Optional(2024-04-06 16:00:00 +0000), date1: nil)
```

**date1** 没有正确的解析出来的。原因是： 日期的格式不对。

那么： 如何处理一个decoder里面一个类型的多种解析策略呢？ 

```
struct Model: SmartCodable {
    var date: Date?
    var date1: Date?
    
    static func mappingForValue() -> [SmartValueTransformer]? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return [
            CodingKeys.date <--- SmartDateTransformer(),
            CodingKeys.date1 <--- SmartDateFormatTransformer(df)
        ]
    }
}

let dict1: [String: Any] = [
    "date": "2024-04-07",
    "date1": 1712491290,
]

guard let model = Model.deserialize(from: dict1) else { return }
print(model)
```

这样就可以针对单独的属性做不同的解析策略。



### 自定义策略

```
"date2": "2015-03-03T02:36:44"
```

新增了一个 **ISO8601** 格式的日期。

```
public struct ISO8601DateTransformer: ValueTransformable {
    public typealias JSON = String
    public typealias Object = Date
    
    let dateFormatter: DateFormatter

    public init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }

    public func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            let date = dateFormatter.date(from: dateString)
            return date
        }
        return nil
    }

    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
```

只需要自己实现一个 **ValueTransformable** 类型即可。 

```
public protocol ValueTransformable {
    associatedtype Object
    associatedtype JSON
    func transformFromJSON(_ value: Any?) -> Object?
    func transformToJSON(_ value: Object?) -> JSON?
}
```

实现对应的方法。
