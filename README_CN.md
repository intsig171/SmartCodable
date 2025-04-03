<p align="center">
<img src="https://github.com/intsig171/SmartCodable/assets/87351449/89de27ac-1760-42ee-a680-4811a043c8b1" alt="SmartCodable" title="SmartCodable" width="500"/>
</p>
<h1 align="center">SmartCodable - Ultimate Codable Enhancement for Swift</h1>

<p align="center">
<a href="https://github.com/intsig171/SmartCodable/actions?query=workflow%3Abuild">
    <img src="https://img.shields.io/github/actions/workflow/status/intsig171/SmartCodable/build.yml?branch=main&label=build" alt="Build Status">
  </a>
<a href="https://github.com/intsig171/SmartCodable/wiki">
    <img src="https://img.shields.io/badge/Documentation-available-brightgreen.svg" alt="Documentation">
</a>
<a href="https://github.com/intsig171/SmartCodable/releases">
    <img src="https://img.shields.io/github/v/release/intsig171/SmartCodable?color=blue&label=version" alt="Latest Release">
</a>
<a href="https://swift.org/package-manager/">
    <img src="https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat" alt="SPM Supported">
</a>
<a href="https://swift.org/">
    <img src="https://img.shields.io/badge/Swift-5.0%2B-orange.svg" alt="Swift 5.0+">
</a>
<a href="https://github.com/intsig171/SmartCodable/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-black.svg" alt="MIT License">
</a>
</p>

### 中文 | [English](https://github.com/intsig171/SmartCodable)

SmartCodable通过增强苹果原生Codable的能力，为Swift数据解析提供了生产级的健壮性和灵活性。当标准Codable在真实数据场景中失败时，SmartCodable能以最简化的样板代码实现防弹解析。

## **SmartCodable vs Codable**

| 功能类别         | 中文描述                                              |
| :--------------- | :---------------------------------------------------- |
| **错误容忍**     | 军用级处理类型不匹配、空值和缺失键                    |
| **类型自适应**   | 自动双向类型转换(字符串⇄数字、数字⇄布尔等)            |
| **默认值回退**   | 解析失败时回退到属性初始化值                          |
| **键映射**       | 多源键映射与优先级系统                                |
| **值转换**       | 自定义值转换器                                        |
| **集合安全**     | 安全集合处理(空数组→nil、无效元素→过滤)               |
| **深度模型化**   | 嵌套JSON结构的递归模型化                              |
| **动态类型**     | 通过`@SmartAny`完整支持`Any`、`[Any]`、`[String:Any]` |
| **命名策略**     | 全局键策略(蛇形命名⇄驼峰命名、首字母大小写)           |
| **生命周期钩子** | `didFinishMapping()`回调用于后处理                    |
| **增量更新**     | 无需完全重新解析的部分模型更新                        |
| **属性包装器**   | 如`@IgnoredKey`、`@SmartFlat`、`@SmartAny`等          |
| **调试支持**     | 内置带路径追踪的解码错误日志                          |
| **路径导航**     | 使用点符号深度访问JSON(`designatedPath: "data.user"`) |
| **属性列表支持** | 原生支持解析PropertyList数据而无需JSON转换            |
| **解析诊断**     | 通过`SmartSentinel.monitorLogs()`实时监控             |



## **SmartCodable vs HandyJSON 对比**

| 🎯 功能特性                | 💬 描述                                             | SmartCodable | HandyJSON |
| :------------------------ | :------------------------------------------------- | :----------- | :-------- |
| **强兼容性**              | 完美处理：**字段缺失** & **空值** & **类型不匹配** | ✅            | ✅         |
| **类型自适应**            | 支持类型间自动转换(如JSON Int转Model String)       | ✅            | ✅         |
| **Any解析**               | 支持解析**[Any], [String: Any]**类型               | ✅            | ✅         |
| **解码回调**              | 提供模型解码完成的**didFinishingMapping**回调      | ✅            | ✅         |
| **默认值初始化**          | 解析失败时使用属性初始值                           | ✅            | ✅         |
| **字符串转模型**          | 支持将JSON字符串解析为模型                         | ✅            | ✅         |
| **枚举解析**              | 提供枚举解析失败的备用值                           | ✅            | ✅         |
| **自定义属性解析-重命名** | 支持自定义解码键(重命名模型属性)                   | ✅            | ✅         |
| **自定义属性解析-忽略**   | 支持忽略特定模型属性的解码                         | ✅            | ✅         |
| **designatedPath支持**    | 支持自定义解析路径                                 | ✅            | ✅         |
| **模型继承**              | Codable对继承支持较弱(可能但不方便)                | ❌            | ✅         |
| **自定义解析路径**        | 指定从JSON层级中开始解析的路径                     | ✅            | ✅         |
| **复杂数据解码**          | 支持解码过程中的高级数据处理(如数据扁平化)         | ✅            | ⚠️         |
| **解码性能**              | SmartCodable平均性能提升30%                        | ✅            | ⚠️         |
| **错误日志**              | 提供兼容性处理的故障排查日志                       | ✅            | ❌         |
| **安全性**                | 实现稳定性和安全性更高                             | ✅            | ❌         |

[👉 **SmartCodable - 与HandyJSON对比**](https://github.com/intsig171/SmartCodable/blob/develop/Document/README/CompareWithHandyJSON.md)

**核心优势**：

- 性能提升30%
- 实现更稳定安全
- 内置错误诊断
- 更优秀的复杂数据处理能力



## **SmartCodable支持的类型对比**

| 类型               | 示例                                 |
| :----------------- | :----------------------------------- |
| **整型**           | `Int`, `Int8-64`, `UInt`, `UInt8-64` |
| **浮点型**         | `Float`, `Double`, `CGFloat`         |
| **布尔型**         | `Bool`(接受`true`/`1`/`"true"`)      |
| **字符串**         | `String`(支持从数字自动转换)         |
| **Foundation类型** | `URL`, `Date`, `Data`, `UIColor`     |
| **枚举**           | 所有`RawRepresentable`枚举           |
| **集合类型**       | `[String: Codable]`, `[Codable]`     |
| **嵌套模型**       | 任何`Codable`自定义类型              |
| **包装器**         | `@SmartAny`, `@IgnoredKey`等         |

## 安装指南

### Swift Package Manager

在`Package.swift`中添加：

```
dependencies: [
    .package(url: "https://github.com/intsig171/SmartCodable.git")
]
```

### CocoaPods

在`Podfile`中添加：

```
pod 'SmartCodable'
```

### 使用示例

```
import SmartCodable

struct User: SmartCodable {
    var name: String = ""
    var age: Int = 0
}
let user = User.deserialize(from: ["name": "John", "age": 30])
```



# 反序列化

要使类/结构体支持从JSON反序列化，需要遵循'SmartCodable'协议。

### 1. 基础用法

遵循'SmartCodable'协议，类需要实现空初始化器：

```
class BasicTypes: SmartCodable {
    var int: Int = 2
    var doubleOptional: Double?
    required init() {}
}
let model = BasicTypes.deserialize(from: json)
```

### 2. 结构体用法

对于结构体，编译器会提供默认的空初始化器：

```
struct BasicTypes: SmartCodable {
    var int: Int = 2
    var doubleOptional: Double?
}
let model = BasicTypes.deserialize(from: json)
```

### 3. 特殊属性支持

#### 3.1 枚举

要使枚举可转换，必须遵循`SmartCaseDefaultable`协议：

```
struct Student: SmartCodable {
    var name: String = ""
    var sex: Sex = .man

    enum Sex: String, SmartCaseDefaultable {
        case man = "man"
        case woman = "woman"
    }
}
let model = Student.deserialize(from: json)
```

#### 关联值枚举解码

使枚举遵循**SmartAssociatedEnumerable**，重写**mappingForValue**方法接管解码过程：

```
struct Model: SmartCodable {
    var sex: Sex = .man
    static func mappingForValue() -> [SmartValueTransformer]? {
        [
            CodingKeys.sex <--- RelationEnumTranformer()
        ]
    }
}

enum Sex: SmartAssociatedEnumerable {    
    case man
    case women
    case other(String)
}

struct RelationEnumTranformer: ValueTransformable {
    typealias Object = Sex
    typealias JSON = String

    func transformToJSON(_ value: Introduce_8ViewController.Sex?) -> String? {
        // 自定义处理
    }
    func transformFromJSON(_ value: Any?) -> Sex? {
        // 自定义处理
    }
}
```

#### 3.2 SmartColor

使用SmartColor解码十六进制颜色，通过`color.peel`获取UIColor对象：

```
struct Model: SmartCodable {
    var color: SmartColor = .color(UIColor.white)
}

let dict = [
    "color": "7DA5E3"
]
guard let model = Model.deserialize(from: dict) else { return }
print(model.color.peel)
```

### 4. 属性包装器

#### 4.1 @SmartAny

Codable不支持Any解析，但可以通过@SmartAny实现：

```
struct Model: SmartCodable {
    @SmartAny var dict: [String: Any] = [:]
    @SmartAny var arr: [Any] = []
    @SmartAny var any: Any?
}
let dict: [String: Any] = [
    "dict": ["name": "Lisa"],
    "arr": [1,2,3],
    "any": "Mccc"
]

let model = Model.deserialize(from: dict)
print(model)
// 输出: Model(dict: ["name": "Lisa"], arr: [1, 2, 3], any: "Mccc")
```

#### 4.2 @IgnoredKey

如果需要忽略属性解析，可以重写`CodingKeys`或使用`@IgnoredKey`：

```
struct Model: SmartCodable {
    @IgnoredKey
    var name: String = ""
}

let dict: [String: Any] = [
    "name": "Mccc"
]

let model = Model.deserialize(from: dict)
print(model)
// 输出: Model(name: "")
```

#### 4.3 @SmartFlat

```
struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
  
    @SmartFlat
    var model: FlatModel?
   
}
struct FlatModel: SmartCodable {
    var name: String = ""
    var age: Int = 0
}

let dict: [String: Any] =  [
    "name": "Mccc",
    "age": 18,
]

let model = Model.deserialize(from: dict)
print(model)
// 输出: Model(name: "Mccc", age: 18, model: FlatModel(name: "Mccc", age: 18))
```

#### 4.4 @SmartPublished

```
class PublishedModel: ObservableObject, SmartCodable {
    required init() {}
    
    @SmartPublished
    var name: ABC?
}

struct ABC: SmartCodable {
    var a: String = ""
}

if let model = PublishedModel.deserialize(from: dict) {
    // 正确访问name属性的Publisher
    model.$name
        .sink { newName in
            print("name属性发生变化，新值为: \(newName)")
        }
        .store(in: &cancellables)
}
```

### 5. 反序列化API

#### 5.1 deserialize

1. **类型安全**
   只有遵循`SmartCodable`的类型(或`[SmartCodable]`数组)才能使用这些方法
2. **输入灵活性**
   支持多种输入格式：
   - 原始字典/数组(`[String: Any]`/`[Any]`)
   - JSON字符串
   - 二进制`Data`

```
public static func deserialize(from dict: [String: Any]?, designatedPath: String? = nil,  options: Set<SmartDecodingOption>? = nil) -> Self?

public static func deserialize(from json: String?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self?

public static func deserialize(from data: Data?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self?

public static func deserializePlist(from data: Data?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self?
```

**1. 多格式输入支持**

| 输入类型   | 使用示例                              | 内部转换              |
| :--------- | :------------------------------------ | :-------------------- |
| 字典/数组  | `Model.deserialize(from: dict或arr)`  | 直接处理原生集合      |
| JSON字符串 | `Model.deserialize(from: jsonString)` | 通过UTF-8转换为`Data` |
| 二进制数据 | `Model.deserialize(from: data)`       | 直接处理              |

**2. 深度路径导航(`designatedPath`)**

```
// JSON结构:
{
  "data": {
    "user": {
      "info": { ...目标内容... }
    }
  }
}

// 访问嵌套数据:
Model.deserialize(from: json, designatedPath: "data.user.info")
```

**路径解析规则**:

1. 点分隔的路径组件
2. 处理字典和数组
3. 任何路径段无效时返回`nil`
4. 空路径返回整个内容

**3. 解码策略(`options`)**

```
let options: Set<SmartDecodingOption> = [
    .key(.convertFromSnakeCase),
    .date(.iso8601),
    .data(.base64)
]
```

| 策略类型       | 可用选项                          | 描述                    |
| :------------- | :-------------------------------- | :---------------------- |
| **键解码**     | `.fromSnakeCase`                  | 蛇形命名→驼峰命名       |
|                | `.firstLetterLower`               | "FirstName"→"firstName" |
|                | `.firstLetterUpper`               | "firstName"→"FirstName" |
| **日期解码**   | `.iso8601`, `.secondsSince1970`等 | 完整Codable日期策略     |
| **数据解码**   | `.base64`                         | 二进制数据处理          |
| **浮点数解码** | `.convertToString`, `.throw`      | NaN/∞处理               |

> ⚠️ **重要**: 每种策略类型只允许一个选项(重复时最后一个生效)

#### 5.2 解码成功后调用的后处理回调

```
struct Model: SmartCodable {
    var name: String = ""
    mutating func didFinishMapping() {
        name = "我是 \(name)"
    }
}
```

#### 5.2 键转换

定义解码时的键映射转换，优先使用第一个非空映射：

```
static func mappingForKey() -> [SmartKeyTransformer]? {
    return [
        CodingKeys.id <--- ["user_id", "userId", "id"],
        CodingKeys.joinDate <--- "joined_at"
    ]
}
```

#### 5.3 **值转换**

在JSON值和自定义类型间转换

**内置值转换器**

| 转换器                         | JSON类型      | 对象类型    | 描述                                                  |
| :----------------------------- | :------------ | :---------- | :---------------------------------------------------- |
| **SmartDataTransformer**       | String        | Data        | Base64字符串和Data对象间转换                          |
| **SmartHexColorTransformer**   | String        | ColorObject | 十六进制颜色字符串转平台特定颜色对象(UIColor/NSColor) |
| **SmartDateTransformer**       | Double/String | Date        | 处理多种日期格式(时间戳Double或String)转Date对象      |
| **SmartDateFormatTransformer** | String        | Date        | 使用DateFormatter处理自定义日期字符串格式             |
| **SmartURLTransformer**        | String        | URL         | 字符串转URL，可选编码和添加前缀                       |

```
struct Model: SmartCodable {
    
    ...
    
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

如果需要额外解析规则，可以自己实现**Transformer**。遵循**ValueTransformable**协议实现要求：

```
public protocol ValueTransformable {
    associatedtype Object
    associatedtype JSON
    
    /// 从'json'转换到'object'
    func transformFromJSON(_ value: Any?) -> Object?
    
    /// 从'object'转换到'json'
    func transformToJSON(_ value: Object?) -> JSON?
}
```

**内置快速转换器辅助**

```
static func mappingForValue() -> [SmartValueTransformer]? {
    [
        CodingKeys.name <--- FastTransformer<String, String>(fromJSON: { json in
            "abc"
        }, toJSON: { object in
            "123"
        }),
        CodingKeys.subModel <--- FastTransformer<TestEnum, String>(fromJSON: { json in
            TestEnum.man
        }, toJSON: { object in
            object?.rawValue
        }),
    ]
}
```

#### 5.4 更新现有模型

可适应任何数据结构，包括嵌套数组结构：

```
struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
}

var dic1: [String : Any] = [
    "name": "mccc",
    "age": 10
]
let dic2: [String : Any] = [
    "age": 200
]
guard var model = Model.deserialize(from: dic1) else { return }
SmartUpdater.update(&model, from: dic2)

// 现在: model是 ["name": mccc, "age": 200].
```

### 6. 特殊支持

#### 6.1 智能字符串化JSON解析

SmartCodable在解码时自动处理字符串化的JSON值，无缝转换为嵌套模型对象或数组，同时保持所有键映射规则：

- **自动解析**：检测并解码字符串化JSON(`"{\"key\":value}"`)为适当对象/数组
- **递归映射**：对解析的嵌套结构应用`mappingForKey()`规则
- **类型推断**：根据属性类型确定解析策略(对象/数组)

```
struct Model: SmartCodable {
    var hobby: Hobby?
    var hobbys: [Hobby]?
}

struct Hobby: SmartCodable {
    var name: String = ""
}

let dict: [String: Any] = [
    "hobby": "{\"name\":\"sleep1\"}",
    "hobbys": "[{\"name\":\"sleep2\"}]",
]

guard let model = Model.deserialize(from: dict) else { return }
```

#### 6.2 兼容性

当属性解析失败时，SmartCodable会对抛出的异常进行兼容处理，确保整个解析过程不会中断：

```
let dict = [
    "number1": "123",
    "number2": "Mccc",
    "number3": "Mccc"
]

struct Model: SmartCodable {
    var number1: Int?
    var number2: Int?
    var number3: Int = 1
}

// 解码结果
// Model(number1: 123, number2: nil, number3: 1)
```

**类型转换兼容性**

当数据类型不匹配时(引发.typeMismatch错误)，SmartCodable会尝试将String类型数据转换为所需的Int类型。

**默认值填充兼容性**

当类型转换失败时，会获取当前解析属性的初始化值进行填充。

#### 6.3 解析超大体积数据

当解析超大体积数据时，尽量避免解析异常的兼容处理，例如：属性中声明了多个属性，且声明的属性类型不匹配。

不需要解析的属性不要使用@IgnoredKey，而是重写CodingKeys来忽略不需要解析的属性。

这样可以大幅提高解析效率。

## **哨兵系统(Sentinel)**

SmartCodable集成了Smart Sentinel，它会监听整个解析过程。解析完成后，会显示格式化的日志信息。

这些信息仅作为辅助信息帮助您发现和纠正问题，并不意味着解析失败。

```
================================  [Smart Sentinel]  ================================
Array<SomeModel> 👈🏻 👀
   ╆━ Index 0
      ┆┄ a: Expected to decode 'Int' but found ‘String’ instead.
      ┆┄ b: Expected to decode 'Int' but found ’Array‘ instead.
      ┆┄ c: No value associated with key.
      ╆━ sub: SubModel
         ┆┄ sub_a: No value associated with key.
         ┆┄ sub_b: No value associated with key.
         ┆┄ sub_c: No value associated with key.
      ╆━ sub2s: [SubTwoModel]
         ╆━ Index 0
            ┆┄ sub2_a: No value associated with key.
            ┆┄ sub2_b: No value associated with key.
            ┆┄ sub2_c: No value associated with key.
         ╆━ Index 1
            ┆┄ sub2_a: Expected to decode 'Int' but found ’Array‘ instead.
   ╆━ Index 1
      ┆┄ a: No value associated with key.
      ┆┄ b: Expected to decode 'Int' but found ‘String’ instead.
      ┆┄ c: Expected to decode 'Int' but found ’Array‘ instead.
      ╆━ sub: SubModel
         ┆┄ sub_a: Expected to decode 'Int' but found ‘String’ instead.
      ╆━ sub2s: [SubTwoModel]
         ╆━ Index 0
            ┆┄ sub2_a: Expected to decode 'Int' but found ‘String’ instead.
         ╆━ Index 1
            ┆┄ sub2_a: Expected to decode 'Int' but found 'null' instead.
====================================================================================
```

如需使用，请开启：

```
SmartSentinel.debugMode = .verbose
public enum Level: Int {
    case none
    case verbose
    case alert
}
```

如需将日志上传到服务器：

```
SmartSentinel.onLogGenerated { logs in  }
```



## 常见问题

如果您想了解更多关于Codable协议和SmartCodable设计思路的内容，请查看：

[👉 **github讨论区**](https://github.com/intsig171/SmartCodable/discussions)

[👉 **SmartCodable测试**](https://github.com/intsig171/SmartCodable/blob/main/Document/README/HowToTest.md)

[👉 **学习SmartCodable**](https://github.com/intsig171/SmartCodable/blob/develop/Document/README/LearnMore.md)



## GitHub星标

![GitHub stars](https://starchart.cc/intsig171/SmartCodable.svg?theme=dark)

## 加入SmartCodable社区 🚀

SmartCodable是一个开源项目，致力于使Swift数据解析更健壮、灵活和高效。我们欢迎所有开发者加入我们的社区！


![JoinUs](https://github.com/user-attachments/assets/7b1f8108-968e-4a38-91dd-b99abdd3e500)

## License

SmartCodable is available under the MIT license. See the LICENSE file for more info.

