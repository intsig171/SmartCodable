# #QA 3 支持属性初始化值填充



在Codable中，如果属性遇到以下情况的值： 

* 字段缺失
* 值为null
* 值类型错误

就会解析异常，抛出DecodingError。

```
do {
    let _decoder = JSONDecoder()
    let decodeValue = try _decoder.decode(type, from: self)
    return decodeValue
} catch {
    SmartLog.logError(error, className: "\(type)")
    return nil
}
```



SmartCodable最初的诉求就是为了解决该问题。进而产生了三个演化的版本。

* 解析失败，使用类型默认值进行填充
* 尝试转换数据类型，如果还是失败，使用默认值填充。
* 解析失败，使用属性初始化的值填充。

当解析失败时：会按照 **尝试转化数据类型 > 属性初始化值 > 属性类型默认值** 进行兼容。



## 使用默认值

```
protocol Defaultable {
    static var defaultValue: Self { get }
}

extension String: Defaultable {
    static var defaultValue: String { "" }
}

extension Bool: Defaultable {
    static var defaultValue: Bool { false }
}

......
```

SmartCodable声明了该协议，为支持Codable的类型实现了该协议。

当解析失败，需要兼容的时候，通过类型T，获取对应的填充值

```
if let value = T.self as? Defaultable.Type {
    return value.defaultValue as! T
}
```



## 转换数据类型

我们会遇到一些有意思的情况： 

声明的属性类型是Bool，但是数据值是： String类型的“true”，“false”等，Int类型的0，1等。在逻辑上它们也是有意义的。为了实现这个转换需求，声明了该协议：

```
fileprivate protocol ValueTransformable {
    static func transformValue(from value: Any) -> Self?
}
```

并为我们需要转换的类型实现了该协议： 

```
extension Bool: ValueTransformable {
    static func transformValue(from value: Any) -> Bool? {
        switch value {
        case let temp as Int:
            if temp == 1 { return true}
            else if temp == 0 { return false }
        case let temp as String:
            if ["1","YES","Yes","yes","TRUE","True","true"].contains(temp) { return true }
            if ["0","NO","No","no","FALSE","False","false"].contains(temp) { return false }
        default:
            break
        }
        return nil
    }
}
```

当解析失败的时候，尝试对值进行类型转换的处理：

```
struct Transformer {
    static func typeTransform(from jsonValue: Any?) -> T? {
        guard let value = jsonValue else { return nil }
        return (T.self as? ValueTransformable.Type)?.transformValue(from: value) as? T
    }
}
```



## 使用属性初始化的值填充

有一个使用者提出，是否可以像HandyJSON一样，当解析失败直接使用初始化值填充。 例如：

```
struct NameModel: SmartCodable {
    var name: String = "我是初始值"
}

let dict: [String: String] = [ : ]
if let model = NameModel.deserialize(dict: dict) {
    print(model.name)
    // 我是初始值
}
```

为了实现该功能，SmartCodable放弃了重写 **JSONKeyedDecodingContainer** 协议方法。 重新实现了 **JSONDecoder**，即： **SmartJSONDecoder**。

使用DecodingDefaults类记录当前正在解析的Model：

```
mutating func recordAttributeValues<T: Decodable>(for type: T.Type, codingPath: [CodingKey]) {
    // 直接使用反射初始化对象，如果T符合SmartDecodable协议
    if let object = type as? SmartDecodable.Type {
        let instance = object.init()
        // 使用反射获取属性名称和值
        let mirror = Mirror(reflecting: instance)
        mirror.children.forEach { child in
            if let key = child.label {
                containers[key] = child.value
            }
        }
        self.typeName = "\(type)"
        self.codingPath = codingPath
    }
}
```

在解析失败的时候，从存储中找到初始值填充。 