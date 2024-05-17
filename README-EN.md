# SmartCodable - Swift Data Parsing

**SmartCodable** is a Swift-based data parsing library that aims to provide more powerful and flexible parsing capabilities by optimizing and rewriting the standard functionalities of the **Codable** protocol. By effectively solving common issues encountered in traditional parsing processes and enhancing the fault tolerance and flexibility of parsing, **SmartCodable** significantly improves the parsing experience.

## Suggestions & Answers

Several users have proposed optimizations or requests for new features. Here are the responses to each suggestion:

| 💡 Suggestion List                                            | Accepted | Reason                                                       |
| ------------------------------------------------------------ | -------- | ------------------------------------------------------------ |
| ① **#suggest 1 Support parsing ignore in mapping methods**   | ❌        | [Reason for not accepting](https://github.com/intsig171/SmartCodable/blob/main/Document/Suggest/#suggest1.md) |
| ② **#suggest 2 Support parsing inheritance relationships like HandyJSON** | ❌        | [Reason for not accepting](https://github.com/intsig171/SmartCodable/blob/main/Document/Suggest/#suggest2.md) |
| ③ **#suggest 3 Support filling initial values**              | ✅        | [Implementation logic](https://github.com/intsig171/SmartCodable/blob/main/Document/Suggest/#suggest3md) |
| ④ **#suggest 4 Provide guidance for replacing HandyJSON**    | ✅        | [Replacement guidance](https://github.com/intsig171/SmartCodable/blob/main/Document/Suggest/#suggest4.md) |
| ⑤ **#suggest 5 Provide a global key mapping strategy**       | ✅        | [Implementation logic](https://github.com/intsig171/SmartCodable/blob/main/Document/Suggest/#suggest5.md) |
| ⑥ **#suggest 6 Support parsing UIColor**                     | ✅        | [Implementation logic](https://github.com/intsig171/SmartCodable/blob/main/Document/Suggest/#suggest6.md) |
| ⑦ **#suggest 7 Add custom conversion strategies for individual values** | ✅        | [Implementation logic](https://github.com/intsig171/SmartCodable/blob/main/Document/Suggest/#suggest7.md) |

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

```
https://github.com/intsig171/SmartCodable.git
```

## Introduction to Using SmartCodable

### 1. Decoding from Dictionaries

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
guard let model = Model.deserialize(from: dict) else { return }
```

### 2. Decoding from Arrays

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
let arr = [dict, dict]
guard let models = [Model].deserialize(from: arr) else { return }
```

### 3. Serialization and Deserialization

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

### 4. Decoding Any

Codable cannot decode **Any** type, which means the property type of the model cannot be **Any**, **[Any]**, **[String: Any]**, etc. This poses a certain challenge to decoding. **SmartAny** is the solution provided by **SmartCodable** to decode **Any**. It can be used directly like **Any**.

```
struct AnyModel: SmartCodable {
    var name: SmartAny?
    var dict: [String: SmartAny] = [:]
    var arr: [SmartAny] = []
}
let dict = [
    "name": "xiao ming",
    "age": 20,
    "dict": inDict,
    "arr": arr
] as [String : Any]

guard let model = AnyModel.deserialize(from: dict) else { return }
print(model.name.peel )
print(model.dict.peel)
print(model.arr.peel)
```

The actual data is wrapped by **SmartAny**, and you need to use **peel** to unwrap the data.

#### Encoding to SmartAny

It also provides a method for reverse conversion:

| From             | To                   | Example                        |
| ---------------- | -------------------- | ------------------------------ |
| `Any`            | `SmartAny`           | `SmartAny(from: "some")`       |
| `[String: Any] ` | `[String: SmartAny]` | `["key2": "value2"].cover`     |
| `[Any]`          | `[SmartAny]`         | `[ ["key3": "value3"] ].cover` |

### 5. Parsing JSON Strings into Models

```
let dict: [String: Any] = [
    "hobby": "{\"name\":\"sleep\"}",
]
guard let model = Model.deserialize(from: dict) else { return }
print(model)

struct Model: SmartCodable {
    var hobby: Hobby?
}

struct Hobby: SmartCodable {
    var name: String = ""
}
```

### 6. Support for Parsing UIColor

```
let dict = [
    "color": "7DA5E3"
]

struct Model: SmartCodable {
    var color: SmartColor?
}

guard let model = Model.deserialize(from: dict) else { return }
print(model.color?.peel)
```

**UIColor** is a `non-final class`. Non-final classes cannot simply implement `Codable`'s `init(from:)`. For more details, see **suggest 6**.

### 7. Decoding Enums

Let the enum conform to **SmartCaseDefaultable**, and use **defaultCase** when decoding fails.

```
struct CompatibleEnum: SmartCodable {

    var enumTest: TestEnum?

    enum TestEnum: String, SmartCaseDefaultable {
        case a
        case b
        case c = "hello"
    }
}
```



## Decoding Strategies in SmartCodable

Decoding strategies in SmartCodable are divided into three stages of operations:

- **Before Decoding**
- Ignoring certain keys during parsing.
- **During Decoding**
- Key mapping strategy.
- Value parsing strategy.
- **After Decoding**
- Callback after decoding is complete.

### [Before Decoding] Ignoring Certain Keys During Parsing

```
struct Model: SmartCodable {
    var name: String = ""
    var ignore: String = ""
    var age: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case name
        case age = "selfAge"
        // Ignore parsing for 'ignore'.
//            case ignore
    }
}
```

Override the current **CodingKeys** to specify which keys to parse. Remove the keys you do not want to parse. The remaining keys are those that need to be parsed.

Of course, you can also rename keys here.

### [During Decoding] Key Mapping Strategy

#### Global Key Mapping Strategy

```
public enum SmartKeyDecodingStrategy : Sendable {
    case useDefaultKeys
    
    // Convert snake_case to camelCase.
    case fromSnakeCase
    
    // Convert first letter to lowercase.
    case firstLetterLower
}
```

Applies to the current parsing session. Only one strategy can be used during a single parsing session, and they cannot be mixed.

```
let option1: SmartDecodingOption = .key(.fromSnakeCase)
guard let model1 = TwoModel.deserialize(from: dict1, options: [option1]) else { return }
```

#### Local Key Mapping Strategy

- Supports custom path parsing.
- Supports renaming fields during parsing.

##### Custom Parsing Path

Cross-layer parsing. Parse the 'name' field in 'sub' to the 'name' property of Model.

```
let dict = [
    "age": 10,
    "sub": [
        "name": "Mccc"
    ]
]
struct Model: SmartCodable {
    var age: Int = 0
    var name: String = ""
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [ CodingKeys.name <--- "sub.name" ]
    }
}
```

##### Renaming Keys

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

Also, you can handle **1-to-many** mapping like `CodingKeys.name <--- ["nickName", "realName"]`. If both values are present, the first one will be chosen.

### [During Decoding] Value Parsing Strategy

#### Global Value Parsing Strategy

SmartDecodingOption provides three decoding options:

```
public enum SmartDecodingOption {
    
    /// Strategy for decoding "Date" values.
    case dateStrategy(JSONDecoder.DateDecodingStrategy)
    
    /// Strategy for decoding "Data" values.
    case dataStrategy(JSONDecoder.DataDecodingStrategy)
    
    /// Strategy for non-conforming floating-point values (IEEE 754 infinity and NaN).
    case floatStrategy(JSONDecoder.NonConformingFloatDecodingStrategy)
}
```

##### Date

```
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let option: JSONDecoder.SmartDecodingOption = .dateStrategy(.formatted(dateFormatter))
guard let model = FeedOne.deserialize(from: json, options: [option]) else { return }
```

##### Data

```
let option: JSONDecoder.SmartDecodingOption = .dataStrategy(.base64)
guard let model = FeedOne.deserialize(from: json, options: [option]) else { return }
guard let data = model.address, let url = String(data: data, encoding: .utf8) { else }
```

##### Float

```
let option: JSONDecoder.SmartDecodingOption = .floatStrategy(.convertFromString(positiveInfinity: "infinity", negativeInfinity: "-infinity", nan: "NaN"))
guard let model1 = FeedOne.deserialize(from: json, options: [option]) else { return }
```

#### Local Value Parsing Strategy

```
struct SmartModel: SmartCodable {
    var date1: Date?
    var date2: Date?
    var url: URL?
            
    // Value parsing strategy
    static func mappingForValue() -> [SmartValueTransformer]? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return [
            CodingKeys.url <--- SmartURLTransformer(prefix: "https://"),
            CodingKeys.date2 <--- SmartDateTransformer(),
            CodingKeys.date1 <--- SmartDateFormatTransformer(format)
        ]
    }
}
```

You can implement `mappingForValue` to set different parsing strategies for each property.

Supported types:

- Date
- UIColor
- URL

For other types, please submit an **issue**.

##### Custom Parsing Strategy

Conform to this protocol and implement the protocol methods.

```
public protocol ValueTransformable {
    associatedtype Object
    associatedtype JSON
    
    /// Transform from 'json' to 'object'.
    func transformFromJSON(_ value: Any?) -> Object?
    
    /// Transform to 'json' from 'object'.
    func transformToJSON(_ value: Object?) -> JSON?
}
```

### [After Decoding] Callback After Decoding is Complete

```
class Model: SmartDecodable {

    var name: String = ""
    var age: Int = 0
    var desc: String = ""
    required init() { }
    
    // Callback after decoding is complete.
    func didFinishMapping() {    
        if name.isEmpty {
            desc = "\(age) years old" + " person"
        } else {
            desc = "\(age) years old" + name
        }
    }
}
```

## Debug Logs

Encountering **SmartLog Error** logs indicates that **SmartCodable** has encountered a parsing issue and has entered compatibility mode. This does not mean that the parsing has failed for this session.

SmartCodable encourages addressing the root cause of parsing issues, i.e., not needing to use SmartCodable's compatibility logic. If compatibility issues arise, modify the property definitions in the Model or request data corrections. To facilitate problem localization, detailed debug logs are provided:

- Error Type: Error type information.
- Model Name: The name of the model where the error occurred.
- Data Node: The decoding path of the data when the error occurred.
- Property Information: The name of the field where the error occurred.
- Error Reason: The specific reason for the error.

```
================ [SmartLog Error] ================
Error Type: 'Key not found error' 
Model Name: Array<Class> 
Data Node: Index 0 → students → Index 0
Property Information: (name) more
Error Reason: No value associated with key CodingKeys(stringValue: "more", intValue: nil) ("more").
==================================================
```

You can adjust the log settings through SmartConfig.

## Further Learning

We provide a detailed example project, which you can download and view the project code.
