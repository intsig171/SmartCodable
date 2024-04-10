# SmartCodable - A Smart Solution for Swift Data Parsing

**SmartCodable** is a Swift-based data parsing library that leverages the **Codable** protocol, aiming to provide more powerful and flexible parsing capabilities. By optimizing and rewriting the standard functionalities of **Codable**, **SmartCodable** effectively addresses common issues encountered in traditional parsing processes, enhancing parsing resilience and flexibility.

## HandyJSON vs Codable

| 🎯 Feature                               | 💬 Feature Description 💬                                      | SmartCodable | HandyJSON |
| --------------------------------------- | ------------------------------------------------------------ | ------------ | --------- |
| ① **Strong Compatibility**              | Perfect compatibility: **Missing fields** & **Null field values** & **Incorrect field types** | ✅            | ✅         |
| ② **Type Adaptation**                   | If JSON is an Int, but the corresponding Model field is a String, it will automatically convert | ✅            | ✅         |
| ③ **Parsing Any**                       | Supports parsing **[Any], [String: Any]** types              | ✅            | ✅         |
| ④ **Decoding Callback**                 | Supports callback when Model decoding is complete, i.e., **didFinishingMapping** | ✅            | ✅         |
| ⑤ **Initialization of Property Values** | Supports using the initial value of the Model property when parsing fails | ✅            | ✅         |
| ⑥ **Modelization of Strings**           | Supports parsing JSON strings into models                    | ✅            | ✅         |
| ⑦ **Parsing of Enums**                  | Supports compatibility when enum parsing fails               | ✅            | ✅         |
| ⑧ **Custom Parsing - Renaming**         | Custom decoding key (renaming decoded Model properties)      | ✅            | ✅         |
| ⑨ **Custom Parsing - Ignoring**         | Ignores decoding of certain Model properties                 | ⚠️            | ✅         |
| ⑩ **Model Inheritance**                 | Codable support is weak in model inheritance relationships, making it inconvenient (can be supported) | ⚠️            | ✅         |
| ⑪ **Custom Parsing Paths**              | Specifies starting from which level in the JSON to parse     | ❌            | ✅         |
| ⑫ **Complex Data Decoding**             | Further integration/processing of data during decoding, e.g., flattening data | ✅            | ⚠️         |
| ⑬ **Decoding Performance**              | SmartCodable is on average 30% stronger in decoding performance | ✅            | ⚠️         |
| ⑭ **Exception Decoding Logs**           | Provides logs for troubleshooting when exceptions are handled during decoding | ✅            | ❌         |
| ⑮ **Safety and Stability**              | Stability and safety of the underlying implementation        | ✅            | ❌         |

Overall, compared to HandyJSON, SmartCodable is similar in terms of functionality and usage.

#### Safety & Stability

- **HandyJSON** uses Swift's reflection features to implement serialization and deserialization. **This mechanism is illegal and unsafe**. More details can be found at **[HandyJSON's issue #466](https://github.com/alibaba/HandyJSON/issues/466)**.

- **Codable** is part of the Swift standard library, providing a declarative way to perform serialization and deserialization, making it more general.

## Suggestions & Answers

Several users have proposed optimization requirements or requests for new features. Here are the responses to each:

| 💡 Suggestion List                                            | Accepted | Reason                                                       |
| ------------------------------------------------------------ | -------- | ------------------------------------------------------------ |
| ① **#suggest 1 Support parsing ignore in mapping method**    | ❌        | [Reason for not accepting](https://github.com/intsig171/SmartCodable/blob/main/Document/建议/%23suggest 1 在mapping方法中支持解析忽略.md) |
| ② **#suggest 2 Support parsing inheritance relationships like HandyJSON** | ❌        | [Reason for not accepting](https://github.com/intsig171/SmartCodable/blob/main/Document/建议/%23suggest 2 像HandyJSON一样支持继承关系的解析.md) |

## Integrating SmartCodable

### Cocoapods Integration

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'MyApp' do
 pod 'SmartCodable'
end
```

### SPM Integration

## Using SmartCodable

### Decoding Dictionaries

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
guard let model = Model.deserialize(from: dict) else { return }
```

### Decoding Arrays

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
let arr = [dict, dict]
guard let models = [Model].deserialize(from: arr) else { return }
```

### Serialization and Deserialization

```
// Dictionary to model
guard let xiaoMing = JsonToModel.deserialize(from: dict) else { return }

// Model to dictionary
let studentDict = xiaoMing.toDictionary() ?? [:]

// Model to JSON string
let json1 = xiaoMing.toJSONString(prettyPrint: true) ?? ""

// JSON string to model
guard let xiaoMing2 = JsonToModel.deserialize(from: json1) else { return }
```

### Decoding Completion Callback

```
class Model: SmartDecodable {

    var name: String = ""
    var age: Int = 0
    var desc: String = ""
    required init() { }
    
    // Decoding completion callback
    func didFinishMapping() {    
        if name.isEmpty {
            desc = "\(age) years old" + " person"
        } else {
            desc = "\(age) years old" + name
        }
    }
}
```

### Custom Parsing Rules

Custom mapping consists of two types:

- Ignoring certain decoding keys
- Renaming decoding keys

Given this dictionary `dict`:

```
let dict = [
    "nickName": "小花",
    "realName": "小明",
    "person_age": 10
] as [String : Any]
```

Parse into `Model`:

```
struct Model: SmartCodable {
    var name: String = ""
    var age: Int?
    var ignoreKey: String?
}
```

Note:

**ignoreKey** property is not to be parsed.

**name** and **age** need to be renamed to the keys in the dictionary.

#### Ignoring Keys

By overriding CodingKeys to provide the properties to be parsed. Properties not provided will be automatically ignored.

```
struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
    var ignoreKey: String?
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
}
```

#### Renaming Keys

Supports custom mapping relationships. You need to implement an optional `mapping` function.

```
struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
    var ignoreKey: String?
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.name <--- ["nickName", "realName"],
            CodingKeys.age <--- "person_age"
        ]
    }
}
```

- **1-to-1** mapping

You can choose `CodingKeys.age <--- "person_age"`, handling **1-to-1** mapping.

- **1-to-many** mapping

Also handle **1-to-many** mapping like `CodingKeys.name <--- ["nickName", "realName"]`. If both have values, the first one will be chosen.

### Decoding Enums

Let the enum conform to **SmartCaseDefaultable**, use **defaultCase** when decoding fails.

```
struct CompatibleEnum: SmartCodable {

    init() { }
    var enumTest: TestEnum = .a

    enum TestEnum: String, SmartCaseDefaultable {
        static var defaultCase: TestEnum = .a

        case a
        case b
        case c = "hello"
    }
}
```

### Decoding Any

Codable cannot decode **Any** type, meaning the property type of the model cannot be **Any**, **[Any]**, **[String: Any]**, etc., causing difficulties in decoding.

**SmartAny** is the solution provided by **SmartCodable** for decoding **Any**. It can be used directly like **Any**.

```
struct AnyModel: SmartCodable {
    var name: SmartAny?
    var dict: [String: SmartAny] = [:]
    var arr: [SmartAny] = []
}
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

guard let model = AnyModel.deserialize(from: dict) else { return }
guard let model = AnyModel.deserialize(from: dict) else { return }
print(model.name.peel )
print(model.age?.peel ?? 0)
print(model.dict.peel)
print(model.arr.peel)    
```

use **peel** unbox data。



## Parsing Options - SmartDecodingOption

SmartDecodingOption provides three decoding options:

```
public enum SmartDecodingOption {
    
    /// Strategy for decoding "Date" values
    case dateStrategy(JSONDecoder.DateDecodingStrategy)
    
    /// Strategy for decoding "Data" values
    case dataStrategy(JSONDecoder.DataDecodingStrategy)
    
    /// Strategy for non-conforming floating-point values (IEEE 754 infinity and NaN)
    case floatStrategy(JSONDecoder.NonConformingFloatDecodingStrategy)
}
```

### Date

```
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let option: SmartDecodingOption = .dateStrategy(.formatted(dateFormatter))
guard let model = FeedOne.deserialize(from: json, options: [option]) else { return }
```

### Data

```
let option: JSONDecoder.SmartDecodingOption = .dataStrategy(.base64)
guard let model = FeedOne.deserialize(from: json, options: [option]) else { return }
guard let data = model.address, let url = String(data: data, encoding: .utf8) else { return }
```

### Float

```
let option: SmartDecodingOption = .floatStrategy(.convertFromString(positiveInfinity: "infinity", negativeInfinity: "-infinity", nan: "NaN"))
guard let model1 = FeedOne.deserialize(from: json, options: [option]) else { return }
```

## Debug Logs

SmartCodable encourages addressing the root cause of parsing issues, meaning that there is no need to use SmartCodable's compatibility logic. If a parsing compatibility issue arises, modify the property definitions in the Model or request corrections from the data provider. To facilitate problem localization, SmartCodable provides convenient parsing error logs.

Debug logs will provide auxiliary information to help locate issues:

- Error Type: Type of error
- Model Name: Name of the model where the error occurred
- Data Node: Decoding path of the data when the error occurred
- Property Information: Name of the field where the error occurred
- Error Reason: Specific reason for the error

```
================ [SmartLog Error] ================
Error Type: 'Key not found error'
Model Name: Array<Class>
Data Node: Index 0 → students → Index 0
Property Information: (Name) more
Error Reason: No value associated with key CodingKeys(stringValue: "more", intValue: nil) ("more").
==================================================

================ [SmartLog Error] ================
Error Type: 'Value type mismatch error'
Model Name: DecodeErrorPrint
Data Node: a
Property Information: (Type) Bool (Name) a
Error Reason: Expected to decode Bool but found a string/data instead.
==================================================

================ [SmartLog Error] ================
Error Type: 'Value not found error'
Model Name: DecodeErrorPrint
Data Node: c
Property Information: (Type) Bool (Name) c
Error Reason: The value corresponding to 'c' in the JSON is null
==================================================
```

You can adjust the log settings through SmartConfig.

##### How to Understand Data Nodes?

![Data Nodes](https://github.com/intsig171/SmartCodable/assets/87351449/255b8244-d121-48f2-9f35-7d28c9286921)

The data on the right is of array type. Note the highlighted content, comparing from outside to inside.

- Index 0: Element at index 0 of the array.
- sampleFive: The element at index 0 corresponds to a dictionary, i.e., the value of the dictionary key 'sampleFive' is an array.
- Index 1: Element at index 1 of the array.
- sampleOne: The value of the dictionary key 'sampleOne'.
- string: The value of the dictionary key 'string'.
