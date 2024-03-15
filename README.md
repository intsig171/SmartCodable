✨✨✨ Looks good? Give a star✨, urgently need support✨✨✨

# SmartCodable - An Intelligent Solution for Swift Data Parsing


大家可以体验develop分支上的 V3.0.1-beta版本。 使用体验上几乎和handyJSON一致。 预计3月20号前结束公测，合并到master。


[中国同胞🇨🇳请访问中文版](https://github.com/intsig171/SmartCodable/blob/main/README-CN.md)



**SmartCodable** is a data parsing library based on the Swift **Codable** protocol, designed to offer more powerful and flexible parsing capabilities. By optimizing and extending the standard functions of **Codable**, **SmartCodable** effectively addresses common issues in traditional parsing processes and enhances the error tolerance and flexibility of parsing.



### Why Choose SmartCodable?

When using the standard **Codable** for data parsing, developers often encounter issues such as missing keys, type mismatches, or null values, which can lead to the failure of the entire parsing process and throw exceptions. **SmartCodable** offers intelligent solutions to these challenges, ensuring the robustness and smoothness of the parsing process.



### Main Features

- **Enhanced Error Handling**: Instead of immediately interrupting the parsing process when encountering issues such as missing keys, type mismatches, or null values, SmartCodable provides more flexible handling options.
- **Value Type Conversion**: If the target type does not match the actual type but can be meaningfully converted, SmartCodable automatically converts the value type to ensure correct data parsing.
- **Default Value Filling**: When a property cannot be parsed, SmartCodable allows for the automatic filling of default values for that property type, such as setting a Boolean field to `false` by default, thereby avoiding the failure of the entire parsing process.
- **Compatibility and Flexibility**: SmartCodable is fully compatible with the standard Codable protocol and offers additional customization options on this basis, adapting to more complex and varied data parsing needs.



### Parsing Efficiency

#### Comparative Analysis of Parsing Performance on Conventional Data Structures at Different Scales

For this comparison, consider arrays with element counts set at different magnitudes: 100, 1,000, and 10,000 items. The parsing time for each of these scenarios will be statistically analyzed across five different parsing solutions.

```
[
    {
        "name": "Anaa Airport",
        "iata": "AAA",
        "icao": "NTGA",
        "coordinates": [-145.51222222222222, -17.348888888888887],
        "runways": [
            {
                "direction": "14L/32R",
                "distance": 1502,
                "surface": "flexible"
            }
        ]
    }
]
```

![解析效率](https://github.com/intsig171/SmartCodable/assets/87351449/abc31831-565b-47a5-817e-ecd002739f5e)

In theory, the parsing efficiency of SmartCodable is lower than that of Codable due to the additional error handling and data transformation features it provides. However, this difference might not be significant if **runways** are not parsed.

SmartCodable is more efficient in parsing enumeration items. Therefore, in this data comparison, the parsing efficiency of SmartCodable could be the highest, even surpassing that of standard Codable.

Specific performance data and test results can be found in the demo project. Please download the project code and access the **Tests.swift** file for more detailed information and actual performance test results.

#### Comparison of big data analysis performance between provinces and cities

![省市区数据对比](https://github.com/intsig171/SmartCodable/assets/87351449/b70aa863-bf3b-436e-a64b-d0ca7c81d6a3)


Demo工程中提供了测试用例，请自行下载工程代码，访问 **AreaTests.swift** 文件。

#### HandyJSON vs Codable

`Codable` and `HandyJSON` are two commonly used methods.

- **HandyJSON** utilizes Swift's reflection features to implement data serialization and deserialization. **This mechanism is unofficial and unsafe**, and more details can be found in **[HandyJSON issue #466](https://github.com/alibaba/HandyJSON/issues/466)**.
- **Codable** is part of the Swift standard library, offering a declarative way to handle serialization and deserialization, making it more versatile.

Comparing these two in terms of performance requires considering different data types and scenarios. Generally, `Codable` may have lower parsing latency than `HandyJSON` in the following cases:

1. **Standard JSON Structures:** When parsing standard and well-formatted JSON data, `Codable` often shows better performance. This is because `Codable` is part of the Swift standard library and benefits from compiler optimizations.
2. **Complex Data Models:** For JSON with multiple layers of nesting and complex structures, `Codable` can be more effective than `HandyJSON`, especially in terms of type safety and compile-time checks.
3. **High Type Safety Scenarios:** `Codable` offers stronger type safety, which helps catch errors at compile time. This type checking can bring performance benefits when dealing with data that strictly adheres to specific models.
4. **Integration with Swift Features:** `Codable` integrates more closely with other Swift features (like type inference, generics, etc.), which might improve parsing efficiency in certain scenarios.

However, these differences are not absolute. `HandyJSON` might perform better in some cases (like dealing with dynamic or unstructured JSON data). Performance can also be affected by the size and complexity of the JSON data, the specific implementation of the application, and the runtime environment. In practice, choosing between `Codable` and `HandyJSON` should be based on the specific project requirements and context.



## How to Use SmartCodable?

Using **SmartCodable** is similar to using the standard **Codable**, but it provides you with additional error handling capabilities and more flexible parsing options. You simply need to make your data models conform to the **SmartCodable** protocol to start enjoying a more intelligent data parsing experience.

### CocoaPods 

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'MyApp' do
  pod 'SmartCodable'
end
```



### Decoding of a dictionary

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
guard let model = Model.deserialize(dict: dict) else { return }
```



### Decoding of an array

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
let arr = [dict, dict]
guard let models = [Model].deserialize(array: arr) else { return }
```



###  Serialization and Deserialization

```
// 字典转模型
guard let xiaoMing = JsonToModel.deserialize(dict: dict) else { return }

// 模型转字典
let studentDict = xiaoMing.toDictionary() ?? [:]

// 模型转json字符串
let json1 = xiaoMing.toJSONString(prettyPrint: true) ?? ""

// json字符串转模型
guard let xiaoMing2 = JsonToModel.deserialize(json: json1) else { return }
```



### Callback for Completed Parsing

```
class Model: SmartDecodable {

    var name: String = ""
    var age: Int = 0
    var desc: String = ""
    required init() { }
    
    // 解析完成的回调
    func didFinishMapping() {    
        if name.isEmpty {
            desc = "\(age)岁的" + "人"
        } else {
            desc = "\(age)岁的" + name
        }
    }
}
```



### Decoding of an enum

```
struct CompatibleEnum: SmartCodable {

    init() { }
    var enumTest: TestEnum = .a

    enum TestEnum: String, SmartCaseDefaultable {
        static var defaultCase: TestEnum = .a

        case a
        case b
        case hello = "c"
    }
}
```

Make your enum conform to the **SmartCaseDefaultable** protocol, so if enum parsing fails, the `defaultCase` will be used as a fallback value.

### Decoding of Any

Codable cannot decode the `Any` type, meaning that model properties cannot be of types like **Any**, **[Any]**, or **[String: Any]**. This creates certain complications for decoding.

#### The official solution

For non-native type fields, create another struct for it and use native types to represent the properties.

```
struct Block: Codable {
    let message: String
    let index: Int
    let transactions: [[String: Any]]
    let proof: String
    let previous_hash: String
}
```

to： 

```
struct Block: Codable {
    let message: String
    let index: Int
    let transactions: [Transaction]
    let proof: String
    let previous_hash: String
}

struct Transaction: Codable {
    let amount: Int
    let recipient: String
    let sender: String
}
```

#### Use generics

If possible, use generics instead.

```
struct AboutAny<T: Codable>: SmartCodable {
    init() { }

    var dict1: [String: T] = [:]
    var dict2: [String: T] = [:]
}
guard let one = AboutAny<String>.deserialize(dict: dict) else { return }
```



#### Use SmartAny

**SmartAny** is a type provided by **SmartCodable** to address the `Any` issue. It can be used just like you would use `Any`.

```
struct AnyModel: SmartCodable {
    var name: SmartAny?
    var age: SmartAny = .int(0)
    var dict: [String: SmartAny] = [:]
    var arr: [SmartAny] = []
}
```



```
let inDict = [
    "key1": 1,
    "key2": "two",
    "key3": ["key": "1"],
    "key4": [1, 2.2]
] as [String : Any]

let arr = [inDict]

let dict = [
    "name": "xiao ming",
    "age": 20,
    "dict": inDict,
    "arr": arr
] as [String : Any]

guard let model = AnyModel.deserialize(dict: dict) else { return }

print(model.name)
// print: Optional(SmartAny.string("xiao ming"))

print(model.age)
// print: SmartAny.int(20)

print(model.dict)
// print:
[
    "key1": SmartAny.int(1),
    "key2": SmartAny.string("two"),
    "key3": SmartAny.dict(["key": SmartAny.string("1")]),
    "key4": SmartAny.array([SmartAny.int(1), SmartAny.double(2.2)])
]

print(model.arr)
// print: 
[
    SmartAny.dict([
        "key1": SmartAny.int(1),
        "key2": SmartAny.string("two")
        "key3": SmartAny.dict(["key": SmartAny.string("1")]),
        "key4": SmartAny.array([SmartAny.int(1), SmartAny.double(2.2)]),
    ])
]
```

You can see that the printed data is wrapped in SmartAny and needs to be shelled using `.peel `.

```
print(model.name?.peel)
print(model.age.peel)
print(model.dict.peel)
print(model.arr.peel)
```







## Parsing option - JSONDecoder.SmartOption

Three decoding options are provided, namely:

```
public enum SmartOption {
    
    /// 用于解码 “Date” 值的策略
    case dateStrategy(JSONDecoder.DateDecodingStrategy)
    
    /// 用于解码 “Data” 值的策略
    case dataStrategy(JSONDecoder.DataDecodingStrategy)
    
    /// 用于不符合json的浮点值(IEEE 754无穷大和NaN)的策略
    case floatStrategy(JSONDecoder.NonConformingFloatDecodingStrategy)
}
```

### Date

```
let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let option: JSONDecoder.SmartOption = .dateStrategy(.formatted(dateFormatter))
guard let model = FeedOne.deserialize(json: json, options: [option]) else { return }
```

### Data

```
let option: JSONDecoder.SmartOption = .dataStrategy(.base64)
guard let model = FeedOne.deserialize(json: json, options: [option]) else { return }
gurad let data = model.address, let url = String(data: data, encoding: .utf8) { else }
```

### Float

```
let option: JSONDecoder.SmartOption = .floatStrategy(.convertFromString(positiveInfinity: "infinity", negativeInfinity: "-infinity", nan: "NaN"))
guard let model1 = FeedOne.deserialize(json: json, options: [option]) else {  return }
```





## Field mapping

If you need to put such a data structure

```
let dict: [String: Any] = [
    "nick_name": "Mccc1",
    "two": [
        "realName": "Mccc2",
        "three": [
            ["nickName": "Mccc3"]
        ]
    ]
]
```

Parse into the Model defined below

```
struct FeedTwo: SmartCodable {
    var nickName: String = ""     
    var two: Two = Two()
}

struct Two: SmartCodable {
    var nickName: String = ""
    var three: [Three] = []
}

struct Three: SmartCodable {
    var nickName: String = ""
}
```

When the field names in the data and the property names in the Model are inconsistent, it is recommended to use **CodingKeys**.

### Override CodingKeys

```
struct FeedTwo: SmartCodable {
    var nickName: String = ""
    var two: Two = Two()
    
    enum CodingKeys: String, CodingKey {
        case nickName = "nick_name"
        case two
    }
}

struct Two: SmartCodable {
    var nickName: String = ""
    var three: [Three] = []
    
    enum CodingKeys: String, CodingKey {
        case nickName = "realName"
        case three
    }
}

struct Three: SmartCodable {
    var nickName: String = ""
    enum CodingKeys: String, CodingKey {
        case nickName = "nick_name"
    }
}

```



### JSONDecoder.SmartDecodingKey

If you have more complex requirements, such as **multi-field mapping**, overriding CodingKeys may not suffice. You can use the provided SmartDecodingKey to solve the problem.

```
public enum SmartDecodingKey {
    /// 使用默认key
    case useDefaultKeys
    
    /// 蛇形命名转换成驼峰命名
    case convertFromSnakeCase
    
    /// 自定义映射关系，会覆盖本次所有映射。
    case globalMap([SmartGlobalMap])
    
    /// 自定义映射关系，仅作用于path路径对应的映射。
    case exactMap([SmartExactMap])
}
```

* **useDefaultKeys:** Use the default parsing mapping method.

* **convertFromSnakeCase:** Convert snake case to camel case, overriding this parsing instance.
* **globalMap:** Customize parsing mapping, overriding this parsing instance.
* **exactMap:** Customize parsing mapping, affecting only the provided path's parsing mapping.

### globalMap

```
let keys = [
    SmartGlobalMap(from: "nick_name", to: "nickName"),
    SmartGlobalMap(from: "realName", to: "nickName"),
]
guard let feedTwo = FeedTwo.deserialize(dict: dict, keyStrategy: .globalMap(keys)) else { return }
```

Map the **nick_name** field in the data to the **nickName** property in the model.

It should be noted that this mapping relationship will also apply to nested data structures.

### exactMap

If you want to avoid the above influence, you can use **exact mapping**.

```
let keys2 = [
    SmartExactMap(path: "", from: "nick_name", to: "nickName"),
    SmartExactMap(path: "two", from: "realName", to: "nickName"),
    SmartExactMap(path: "two.three", from: "nick_name", to: "nickName"),
]
guard let feedThree = FeedTwo.deserialize(dict: dict, keyStrategy: .exactMap(keys2)) else { return }
```

You need to understand: How to fill in the **path**?

The path represents the level where the field you want to map is located. If it's already at the top level, fill in the path as `path: ""`.

## Compatibility of SmartCodable

When using the system's **Codable** for decoding, encountering issues like **missing keys**, **null values**, or **incorrect value types** can throw exceptions and cause parsing failures. **SmartCodable** by default is designed to be compatible with these three types of parsing errors.

### Missing Keys & Null Values

These two scenarios are referred to as **irredeemable data**, which cannot be salvaged.

When encountering **missing keys & null values**, SmartCodable will provide a default value of the field's type for parsing and filling (if it's an optional type, it provides nil), allowing the parsing to proceed smoothly.

For these two types of data, when parsing into the **CompatibleTypes** model.

```
var json: String {
   """
   {
   }
   """
}
```

```
var json: String {
   """
   {
     "a": null,
     "b": null,
     "c": null,
     "d": null,
     "e": null,
     "f": null,
     "g": null,
     "h": null,
     "i": null,
     "j": null,
     "k": null,
     "l": null,

     "v": null,
     "w": null,
     "x": null,
     "y": null,
     "z": null
   }
   """
}
```



```
struct CompatibleTypes: SmartDecodable {

    var a: String = ""
    var b: Bool = false
    var c: Date = Date()
    var d: Data = Data()

    var e: Double = 0.0
    var f: Float = 0.0
    var g: CGFloat = 0.0

    var h: Int = 0
    var i: Int8 = 0
    var j: Int16 = 0
    var k: Int32 = 0
    var l: Int64 = 0

    var m: UInt = 0
    var n: UInt8 = 0
    var o: UInt16 = 0
    var p: UInt32 = 0
    var q: UInt64 = 0

    var v: [String] = []
    var w: [String: [String: Int]] = [:]
    var x: [String: String] = [:]
    var y: [String: Int] = [:]
    var z: CompatibleItem = CompatibleItem()
}

class CompatibleItem: SmartDecodable {
    var name: String = ""
    var age: Int = 0   
    required init() { }
}
```

Once the parsing is complete, it is populated with the default value of the data type corresponding to the property.

```
guard let person = CompatibleTypes.deserialize(json: json) else { return }
/**
 "属性：a 的类型是 String， 其值为 "
 "属性：b 的类型是 Bool， 其值为 false"
 "属性：c 的类型是 Date， 其值为 2001-01-01 00:00:00 +0000"
 "属性：d 的类型是 Data， 其值为 0 bytes"
 "属性：e 的类型是 Double， 其值为 0.0"
 "属性：f 的类型是 Float， 其值为 0.0"
 "属性：g 的类型是 CGFloat， 其值为 0.0"
 "属性：h 的类型是 Int， 其值为 0"
 "属性：i 的类型是 Int8， 其值为 0"
 "属性：j 的类型是 Int16， 其值为 0"
 "属性：k 的类型是 Int32， 其值为 0"
 "属性：l 的类型是 Int64， 其值为 0"
 "属性：m 的类型是 UInt， 其值为 0"
 "属性：n 的类型是 UInt8， 其值为 0"
 "属性：o 的类型是 UInt16， 其值为 0"
 "属性：p 的类型是 UInt32， 其值为 0"
 "属性：q 的类型是 UInt64， 其值为 0"
 "属性：v 的类型是 Array<String>， 其值为 []"
 "属性：w 的类型是 Dictionary<String, Dictionary<String, Int>>， 其值为 [:]"
 "属性：x 的类型是 Dictionary<String, String>， 其值为 [:]"
 "属性：y 的类型是 Dictionary<String, Int>， 其值为 [:]"
 "属性：z 的类型是 CompatibleItem， 其值为 CompatibleItem(name: \"\", age: 0)"
 */
```



### Incorrect Value Type

I refer to this kind of data as **salvageable data**. For instance, a Bool type defined in the Model, but the data returns an Int type of 0 or 1, or a String type like True/true/Yes/No, etc.

When encountering an **incorrect value type**, SmartCodable will attempt to convert the data value to the appropriate type. If the conversion is successful, that value will be used. If the conversion fails, the default value for the corresponding data type of the property will be used to fill in.

#### Conversion for Bool Type

```
/// 兼容Bool类型的值，Model中定义为Bool类型，但是数据中是String，Int的情况。
static func compatibleBoolType(value: Any) -> Bool? {
    switch value {
    case let intValue as Int:
        if intValue == 1 {
            return true
        } else if intValue == 0 {
            return false
        } else {
             return nil
        }
    case let stringValue as String:
        switch stringValue {
        case "1", "YES", "Yes", "yes", "TRUE", "True", "true":
            return true
        case "0",  "NO", "No", "no", "FALSE", "False", "false":
            return false
        default:
            return nil
        }
    default:
        return nil
    }
}
```



#### The String type is converted

```
/// 兼容String类型的值
static func compatibleStringType(value: Any) -> String? {
    
    switch value {
    case let intValue as Int:
        let string = String(intValue)
        return string
    case let floatValue as Float:
        let string = String(floatValue)
        return string
    case let doubleValue as Double:
        let string = String(doubleValue)
        return string
    default:
        return nil
    }
}
```



#### Other Types

Please refer to **TypePatcher.swift** for more information.



## Debugging Logs

SmartCodable encourages solving parsing issues fundamentally, which means: not needing to rely on SmartCodable's compatibility logic. If a parsing compatibility issue arises, modify the property definitions in the Model or request the data provider to make corrections. To more conveniently pinpoint issues, SmartCodable provides convenient parsing error logs.

The debugging logs will provide auxiliary information to help locate the problem:

* 错误类型:  The incorrect type information.
* 模型名称：The name of the model where the error occurred.
* 数据节点：The decoding path of the data at the time of the error.
* 属性信息：The name of the field where the error occurred.
* 错误原因:   The specific reason for the error.

```
================ [SmartLog Error] ================
错误类型: '找不到键的错误' 
模型名称：Array<Class> 
数据节点：Index 0 → students → Index 0
属性信息：（名称）more
错误原因: No value associated with key CodingKeys(stringValue: "more", intValue: nil) ("more").
==================================================

================ [SmartLog Error] ================
错误类型: '值类型不匹配的错误' 
模型名称：DecodeErrorPrint 
数据节点：a
属性信息：（类型）Bool （名称）a
错误原因: Expected to decode Bool but found a string/data instead.
==================================================


================ [SmartLog Error] ================
错误类型: '找不到值的错误' 
模型名称：DecodeErrorPrint 
数据节点：c
属性信息：（类型）Bool （名称）c
错误原因:  c 在json中对应的值是null
==================================================
```

You can adjust the log Settings using SmartConfig.



##### How to understand data nodes?

![数据节点](https://github.com/intsig171/SmartCodable/assets/87351449/255b8244-d121-48f2-9f35-7d28c9286921)

The data on the right is of an array type. Pay attention to the content highlighted in red, and check it from the outside to the inside.

- Index 0: The element at index 0 of the array.
- sampleFive: The element at index 0 corresponds to a dictionary, i.e., the value corresponding to the dictionary key 'sampleFive' (which is an array).
- Index 1: The element at index 1 of the array.
- sampleOne: The value corresponding to the key 'sampleOne' in the dictionary.
- string: The value corresponding to the key 'string' in the dictionary.





## Disadvantages of SmartCodable

### 1. Optional Model Properties

```
struct Feed: SmartCodable {
    var one: FeedOne?
}
struct FeedOne: SmartCodable {
    var name: String = ""
}
```

If a property in the model is a nested model property and encounters a type mismatch, Codable will fail to parse and throw an exception. In such cases, SmartCodable will not be able to handle the exception.

In this scenario, you have two options:

- Set the `one` property in the Feed as non-optional. SmartCodable will then work normally.
- Decorate the property with the **@SmartOptional** property wrapper.

```
struct Feed: SmartCodable {
    @SmartOptional var one: FeedOne?
}

class FeedOne: SmartCodable {
    var name: String = ""
    required init() { }
}
```

**This is a last resort implementation**:

In order to accommodate decoding failures, we have overridden the **decode** and **decodeIfPresent** methods in **KeyedEncodingContainer**.

It is important to note that the underlying implementation of **decodeIfPresent** still uses **decode**.

```
// 系统Codable源码实现
public extension KeyedDecodingContainerProtocol {
    @_inlineable // FIXME(sil-serialize-all)
    public func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
        guard try self.contains(key) && !self.decodeNil(forKey: key) else { return nil }

        return try self.decode(Bool.self, forKey: key)
    }
}
```

The KeyedEncodingContainer container is implemented using a structure. After overriding the methods of the structure, it's not possible to call the parent methods.

1. In this case, if you override the `public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T?` method, it would lead to recursive calls of the method.
2. When decorating an optional property with the SmartOptional property wrapper, it generates a new type. Decoding this new type will not go through `decodeIfPresent`, but rather through the `decode` method.

#### Three Limitations of Using SmartOptional

- Must conform to the SmartDecodable protocol.

- Must be an optional property.

  If it's not an optional property, there's no need to use SmartOptional.

- Must be a class type.

  If the model is a Struct, which is a value type, it's not possible to initialize properties decorated with property wrappers during the execution of **didFinishMapping**. Consequently, this makes it ineffective to modify values after decoding is complete.

**If you have a better solution, you can propose it in an issue.**





### 2. Default Values Set in the Model Are Ineffective

When Codable performs decoding, it cannot be aware of a property's default value. Therefore, during decoding, if parsing fails and it attempts to fill in with a default value, it cannot access this default value. In handling decoding compatibility, one can only generate a default value for the corresponding type to fill in.

**If you have a better solution, you can propose it in an issue.**

## Further Learning

We provide detailed example projects, which you can download and view the project code for more understanding.![示例](https://github.com/intsig171/SmartCodable/assets/87351449/876c5538-65a7-4b56-ac25-44800ad19bd3)



### Learn More About Codable & SmartCodable

This is a series of articles on Swift data parsing solutions:

[Swift数据解析(第一篇) - 技术选型](https://juejin.cn/post/7288517000581070902)

[Swift数据解析(第二篇) - Codable 上](https://juejin.cn/post/7288517000581087286)

[Swift数据解析(第二篇) - Codable 下](https://juejin.cn/post/7288517000581120054)

[Swift数据解析(第三篇) - Codable源码学习](https://juejin.cn/post/7288504491506090023)

[Swift数据解析(第四篇) - SmartCodable 上](https://juejin.cn/post/7288513881735151670)

[Swift数据解析(第四篇) - SmartCodable 下](https://juejin.cn/post/7288517000581169206)



### Contact Us

![QQ](https://github.com/intsig171/SmartCodable/assets/87351449/a90560b0-7d4f-4529-a523-0d8d5b51ebe7)



## Join Us

**SmartCodable** is an open-source project, and we welcome developers who are interested in improving data parsing performance and robustness to join us. Whether it's user feedback, feature suggestions, or code contributions, your participation will greatly advance the development of the **SmartCodable** project.
