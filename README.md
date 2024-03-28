✨✨✨看起来还不错？给个star✨吧，急需支持✨✨✨

# SmartCodable - Swift数据解析

**SmartCodable** 是一个基于Swift的**Codable**协议的数据解析库，旨在提供更为强大和灵活的解析能力。通过优化和重写**Codable**的标准功能，**SmartCodable** 有效地解决了传统解析过程中的常见问题，并提高了解析的容错性和灵活性。

## English ReadMe 

🌐 If you need,please visit [English README](https://github.com/intsig171/SmartCodable/blob/main/README-EN.md)


## HandyJSON vs Codable

【✅： 完美支持】【⚠️： 带缺陷的支持】【❌： 不支持】

| 🎯 特性                    | 💬 特性说明 💬                                                 | SmartCodable | HandyJSON |
| ------------------------- | ------------------------------------------------------------ | ------------ | --------- |
| ① **强大的兼容性**        | 完美兼容：**字段缺失** & **字段值为nul** & **字段类型错误**  | ✅            | ✅         |
| ② **类型自适应**          | 如JSON中是一个Int，但对应Model是String字段，会自动完成转化   | ✅            | ✅         |
| ③ **解析Any**             | 支持解析 **[Any], [String: Any]** 等类型                     | ✅            | ✅         |
| ④ **解码回调**            | 支持Model解码完成的回调，即：**didFinishingMapping**         | ✅            | ✅         |
| ⑤ **属性初始化值填充**    | 当解析失败时，支持使用初始的Model属性的赋值。                | ✅            | ✅         |
| ⑥ **字符串的Model化** | 字符串是json字符串，支持进行Model化解析                  | ✅            | ✅         |
| ⑦ **枚举的解析**          | 当枚举解析失败时，支持兼容。                                 | ✅            | ✅         |
| ⑧ **自定义解析** - 重命名 | 自定义解码key（对解码的Model属性重命名）                     | ✅            | ✅         |
| ⑨ **自定义解析** - 忽略   | 忽略某个Model属性的解码                                      | ⚠️            | ✅         |
| ⑩ **Model的继承**         | 在model的继承关系下，Codable的支持力度较弱，使用不便（可以支持） | ❌          | ✅         |
| ⑪ **自定义解析路径**      | 指定从json的层级开始解析                                     | ✅           | ✅         |
| ⑫ **超复杂的数据解码**    | 解码过程中，多数据做进一步的整合/处理。如： 数据的扁平化处理 | ✅            | ⚠️         |
| ⑬ **解码性能**            | 在解码性能上，SmartCodable 平均强 30%                        | ✅            | ⚠️         |
| ⑭ **异常解码日志**        | 当解码异常进行了兼容处理时，提供排查日志                     | ✅            | ❌         |
| ⑮ **安全性方面**          | 底层实现的稳定性和安全性。                                   | ✅            | ❌         |

整体来讲： SmartCodable 和  HandyJSON 相比，在功能和使用上相近。


#### 安全性 & 稳定性

* **HandyJSON** 使用Swift的反射特性来实现数据的序列化和反序列化。**该机制是非法的，不安全的**， 更多的细节请访问 **[HandyJSON 的466号issue](https://github.com/alibaba/HandyJSON/issues/466)**.

* **Codable** 是Swift标准库的一部分，提供了一种声明式的方式来进行序列化和反序列化，它更为通用。



## 建议 & 回答

有不少使用者提出了优化需求 或 新功能的要求。在这边逐一回复：

| 💡 建议列表                                         | 是否采纳 | 理由                                                         |
| -------------------------------------------------- | -------- | ------------------------------------------------------------ |
| ① **#suggest 1 在mapping方法中支持解析忽略**       | ❌        | [不采纳的理由](https://github.com/intsig171/SmartCodable/blob/main/Document/建议/%23suggest%201%20在mapping方法中支持解析忽略.md) |
| ② **#suggest 2 像HandyJSON一样支持继承关系的解析** | ❌        | [不采纳的理由](https://github.com/intsig171/SmartCodable/blob/main/Document/建议/%23suggest%202%20像HandyJSON一样支持继承关系的解析.md) |
| ③ **#suggest 3 支持初始值填充**                    | ✅        | [实现逻辑](https://github.com/intsig171/SmartCodable/blob/main/Document/建议/%23suggest%203%20支持属性初始化值填充.md) |
| ④ **#suggest 4 提供HandyJSON的替换指导**           | ✅        | [替换指导](https://github.com/intsig171/SmartCodable/blob/main/Document/建议/%23suggest%204%20使用SmartCodable%20平替%20HandyJSON.md) |
| ⑤ **#suggest 5 提供全局的Key映射策略**             | ✅        | [实现逻辑](https://github.com/intsig171/SmartCodable/blob/main/Document/建议/%23suggest%205%20提供全局的Key映射策略.md) |


## 使用SmartCodable 平替 HandyJSON
更多内容请查看： [替换指导](https://github.com/intsig171/SmartCodable/blob/main/Document/建议/%23suggest%204%20使用SmartCodable%20平替%20HandyJSON.md) 

| 内容项          | 内容项说明                                    | 使用场景 | 替换难度 | 评判理由                                               |
| --------------- | --------------------------------------------- | -------- | -------- | ------------------------------------------------------ |
| ①声明Model      | 声明Model                                     | ★★★★★    | ★☆☆☆☆    | 全局将 HandyJSON 替换为 SmartCodable即可。             |
| ②反序列化       | 数据的模型化（数据转Model）                   | ★★★★★    | ☆☆☆☆☆    | 完全一样的调用方式，无需处理。                         |
| ③序列化         | 模型的数据化（Model转数据）                   | ★☆☆☆☆    | ★☆☆☆☆    | 将 `toJSON()` 替换为 `toDictionary()` 或 `toArray()`。 |
| ④解码完成的回调 | 解析完成进一步处理数据                        | ★★☆☆☆    | ☆☆☆☆☆    | 完全一样的调用方式，无需处理。                         |
| ⑤自定义解析Key  | 忽略key的解析 & 自定义Key的映射关系           | ★★★☆☆    | ★★★★★    | 需要更改调用方式。                                     |
| ⑥解析Any        | 解析Any类型的数据。Any，[String: Any]， [Any] | ★☆☆☆☆    | ★☆☆☆☆    | 将Any替换为SmartAny                                    |
| ⑦处理继承关系   | 解析存在的继承关系的Model                     | ★☆☆☆☆    | ★★★★★    | 建议使用协议实现。                                     |
| ⑧枚举的解析     | 解析枚举属性                                  | ★☆☆☆☆    | ★☆☆☆☆    | 多实现一个 defaultCase                                 |




## 集成 SmartCodable

### cocopods 集成

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'MyApp' do
  pod 'SmartCodable'
end
```

### SPM 集成 





## SmartCodable 使用

### 字典的解码

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
guard let model = Model.deserialize(from: dict) else { return }
```



### 数组的解码

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
let arr = [dict, dict]
guard let models = [Model].deserialize(from: arr) else { return }
```



###  序列化与反序列化

```
// 字典转模型
guard let xiaoMing = JsonToModel.deserialize(from: dict) else { return }

// 模型转字典
let studentDict = xiaoMing.toDictionary() ?? [:]

// 模型转json字符串
let json1 = xiaoMing.toJSONString(prettyPrint: true) ?? ""

// json字符串转模型
guard let xiaoMing2 = JsonToModel.deserialize(from: json1) else { return }
```



### 解析完成的回调

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



### 自定义解析路径

跨层解析。将sub里面的name字段，解析到 Model的name属性上。

```
let dict = [
    "age": 10,
    "sub": [
        "name": "Mccc"
    ]
]
```

```
struct Model: SmartCodable {
    var age: Int = 0
    var name: String = ""
    static func mapping() -> [MappingRelationship]? {
        [ CodingKeys.name <--- "sub.name" ]
    }
}
```



### 自定义全局的解析策略

全局代表当前本次解析。 目前支持两种策略：

* 蛇形命名转驼峰命名
* 首字母大写转小写

#### 蛇形命名转驼峰命名

```
let dict1: [String: Any] = [
    "nick_name": "Mccc",
    "self_age": 10,
    "sub_info": [
        "real_name": "小李"
    ]
]
```

```
struct TwoModel: SmartCodable {
    var nickName: String = ""
    var selfAge: Int = 0
    var subInfo: SubTwoModel?
}

struct SubTwoModel: SmartCodable {
    var realName: String = ""
}
```

设置一个key的解析选项，影响本次解析。

```
let option1: SmartDecodingOption = .key(.fromSnakeCase)
guard let model1 = TwoModel.deserialize(from: dict1, options: [option1]) else { return }
```

#### 首字母大写转小写

```
let dict: [String: Any] = [
    "Name": "Mccc",
    "Age": 10,
    "Sex": "男",
    "sub": [
        "Name": "小李"
    ]
]
```

```
struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
    var sex: String = ""
    var sub: SubModel?
}

struct SubModel: SmartCodable {
    var name: String = ""
}
```

设置一个key的解析选项，影响本次解析。

```
let option: SmartDecodingOption = .key(.firstLetterLower)
guard let model = Model.deserialize(from: dict, options: [option]) else { return }
```



### 自定义解析规则

自定义映射分为两种： 

* 忽略某些解码的key
* 将解码的key重命名

将这个字典dict

```
let dict = [
    "nickName": "小花",
    "realName": "小明",
    "person_age": 10
] as [String : Any]
```

解析到Model中

```
struct Model: SmartCodable {
    var name: String = ""
    var age: Int?
    var ignoreKey: String?
}
```

需要注意的是： 

**ignoreKey** 属性是不需要解析的。

**name** 和 **age** 需要重命名到字典中的key上。



#### 忽略key

通过重写CodingKeys提供要解析的属性。未提供的属性会自动忽略解析。

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



#### 重命名key

支持自定义映射关系，你需要实现一个可选的`mapping`函数。

```
struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
    var ignoreKey: String?
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
    
    static func mapping() -> [MappingRelationship]? {
        [
            CodingKeys.name <--- ["nickName", "realName"],
            CodingKeys.age <--- "person_age"
        ]
    }
}
```

* **1对1** 的映射

  你可以选择像 `CodingKeys.age <--- "person_age" `，只处理**1对1**的映射。

* **1对多** 的映射

  也可以像 `CodingKeys.name <--- ["nickName", "realName"]` 一样处理 **1对多** 的映射。如果恰好都有值，将选择第一个。





### 枚举的解码

让枚举遵循 **SmartCaseDefaultable** ，当解码失败时使用 **defaultCase**。

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



### 解码Any

Codable是无法解码Any类型的，这样就意味着模型的属性类型不可以是 **Any**，**[Any]**，**[String: Any]**等类型， 这对解码造成了一定的困扰。

**SmartAny** 是**SmartCodable** 提供的解决Any的方案。可以直接像使用 **Any** 一样使用它。 

```
struct AnyModel: SmartCodable {
    var name: SmartAny?
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

guard let model = AnyModel.deserialize(from: dict) else { return }
guard let model = AnyModel.deserialize(from: dict) else { return }
print(model.name.peel )
print(model.age?.peel ?? 0)
print(model.dict.peel)
print(model.arr.peel)
```

需要使用 **peel** 对数据解包。



同时也提供了反向转换的方法：

* Any ➡️ SmartAny
* [Any] ➡️ [SmartAny]
* [String: Any] ➡️ [String: SmartAny]

```
let name = SmartAny(from: "新名字")
let dict1 = ["key2": "value2"].cover
let arr1 = [ ["key3": "value3"] ].cover
```



## 解析选项 - SmartDecodingOption

SmartDecodingOption提供了三种解码选项，分别为：

```
public enum SmartDecodingOption {
    
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
let option: JSONDecoder.SmartDecodingOption = .dateStrategy(.formatted(dateFormatter))
guard let model = FeedOne.deserialize(from: json, options: [option]) else { return }
```

### Data

```
let option: JSONDecoder.SmartDecodingOption = .dataStrategy(.base64)
guard let model = FeedOne.deserialize(from: json, options: [option]) else { return }
gurad let data = model.address, let url = String(data: data, encoding: .utf8) { else }
```

### Float

```
let option: JSONDecoder.SmartDecodingOption = .floatStrategy(.convertFromString(positiveInfinity: "infinity", negativeInfinity: "-infinity", nan: "NaN"))
guard let model1 = FeedOne.deserialize(from: json, options: [option]) else {  return }
```



## 调试日志

出现 **SmartLog Error** 日志代表着 **SmartCodable** 遇到了解析问题，走进了兼容。 并不代表着本次解析失败。

SmartCodable鼓励从根本上解决解析中的问题，即：不需要用到SmartCodable的兼容逻辑。 如果出现解析兼容的情况，修改Model中属性的定义，或要求数据方进行修正。为了更方便的定位问题。

调试日志，将提供辅助信息，帮助定位问题：

* 错误类型:  错误的类型信息
* 模型名称：发生错误的模型名出
* 数据节点：发生错误时，数据的解码路径。
* 属性信息：发生错误的字段名。
* 错误原因:  错误的具体原因。

```
================ [SmartLog Error] ================
错误类型: '找不到键的错误' 
模型名称：Array<Class> 
数据节点：Index 0 → students → Index 0
属性信息：（名称）more
错误原因: No value associated with key CodingKeys(stringValue: "more", intValue: nil) ("more").
==================================================
```

你可以通过SmartConfig 调整日志的相关设置。



## 进一步了解

我们提供了详细的示例工程，可以下载工程代码查看。






### 了解更多关于Codable & SmartCodable

这是Swift数据解析方案的系列文章：

[Swift数据解析(第一篇) - 技术选型](https://juejin.cn/post/7288517000581070902)

[Swift数据解析(第二篇) - Codable 上](https://juejin.cn/post/7288517000581087286)

[Swift数据解析(第二篇) - Codable 下](https://juejin.cn/post/7288517000581120054)

[Swift数据解析(第三篇) - Codable源码学习](https://juejin.cn/post/7288504491506090023)

[Swift数据解析(第四篇) - SmartCodable 上](https://juejin.cn/post/7288513881735151670)

[Swift数据解析(第四篇) - SmartCodable 下](https://juejin.cn/post/7288517000581169206)



### 联系我们

![QQ](https://github.com/intsig171/SmartCodable/assets/87351449/5d3a98fe-17ba-402f-aefe-3e7472f35f82)




## 加入我们

**SmartCodable** 是一个开源项目，我们欢迎所有对提高数据解析性能和健壮性感兴趣的开发者加入。无论是使用反馈、功能建议还是代码贡献，你的参与都将极大地推动 **SmartCodable** 项目的发展。
