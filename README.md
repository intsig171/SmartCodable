
✨✨✨看起来还不错？给个star✨吧，急需支持✨✨✨

# SmartCodable - Swift数据解析的智能解决方案

**SmartCodable** 是一个基于Swift的**Codable**协议的数据解析库，旨在提供更为强大和灵活的解析能力。通过优化和扩展**Codable**的标准功能，**SmartCodable** 有效地解决了传统解析过程中的常见问题，并提高了解析的容错性和灵活性。



### 为何选择SmartCodable?

在使用标准的**Codable**进行数据解析时，开发者常常会遇到诸如键不存在、类型不匹配或值为null等问题，这些问题往往会导致整个解析过程的失败，并抛出异常。**SmartCodable** 针对这些挑战提供了智能化的解决方案，确保解析过程的健壮性和流畅性。

### 主要特性

- **增强的错误处理**：当遇到键不存在、类型不匹配或值为null等问题时，不会立即中断解析，而是提供了更为灵活的处理选项。
- **值类型转换**：如果目标类型与实际类型不符但可以进行有意义的转换，**SmartCodable** 会自动转换值类型，确保数据的正确解析。
- **默认值填充**：当某个属性无法解析时，**SmartCodable** 允许自动填充该属性类型的默认值，例如将Bool类型的字段默认设为`false`，从而避免了整个解析过程的失败。
- **兼容性和灵活性**：**SmartCodable** 完全兼容标准的**Codable**协议，并在此基础上提供更多的定制化选项，适应更复杂和多变的数据解析需求。



### 解析效率

![解析效率](https://github.com/intsig171/SmartCodable/assets/87351449/abc31831-565b-47a5-817e-ecd002739f5e)


使用这样的数组，数组的元素项分别设置为： 100个，1000个，10000个。分别对这五种解析方案进行解析耗时的统计。

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

理论上SmartCodable的解析效率是低于Codable的。如果不解析 **runways** ，就是如此。 
SmartCodable对于枚举项的解析更加高效。所以在本次数据对比中，解析效率最高，甚至高于Codable。


作者使用的是单元测试中的 **measure** 函数进行性能测算。

```
struct Smart: SmartCodable {
    
    var name: String?
    var iata: String?
    var icao: String?
    var coordinates: [Double]?
    var runways: [Runway]?
    
    struct Runway: SmartCodable {
        var direction: String?
        var distance: Int?
        var surface: Surface?
    }
}

func testSmart() {
    measure {
        guard let objects = [Smart].deserialize(data: data)  else {
            return
        }
        XCTAssertEqual(objects.count, count)
    }
}
```

Demo工程中提供了测试用例，请自行下载工程代码，访问 **Tests.swift** 文件。



#### HandyJSON vs Codable

`Codable`和`HandyJSON`是两种常用的方法。

* **HandyJSON** 使用Swift的反射特性来实现数据的序列化和反序列化。**该机制是非法的，不安全的**， 更多的细节，可以访问 **[HandyJSON 的466号issue](https://github.com/alibaba/HandyJSON/issues/466)**.

* **Codable** 是Swift标准库的一部分，提供了一种声明式的方式来进行序列化和反序列化，它更为通用。

比较这两者在性能方面的差异需要考虑不同的数据类型和场景。一般而言，`Codable`在以下情况下可能具有比`HandyJSON`更低的解析耗时：

1. **标准的JSON结构：** 当解析标准且格式良好的JSON数据时，`Codable`通常表现出较好的性能。这是因为`Codable`是Swift标准库的一部分，得到了编译器的优化。
2. **复杂数据模型：** 对于包含多层嵌套和复杂数据结构的JSON，`Codable`可能比`HandyJSON`更有效，特别是在类型安全和编译时检查方面。
3. **类型安全性高的场景：** `Codable`提供了更强的类型安全性，这有助于在编译时捕捉错误。在处理严格遵循特定模型的数据时，这种类型检查可能带来性能优势。
4. **与Swift特性集成：** `Codable`与Swift的其他特性（如类型推断、泛型等）集成得更紧密，这可能在某些情况下提高解析效率。

然而，这些差异并不是绝对的。`HandyJSON`在某些情况下（如处理动态或非结构化的JSON数据）可能表现得更好。性能也会受到JSON数据的大小和复杂性、应用的具体实现方式以及运行时环境等因素的影响。实际应用中，选择`Codable`或`HandyJSON`应基于具体的项目需求和上下文。





## 如何使用SmartCodable?

使用**SmartCodable**与使用标准的**Codable**类似，但你会获得额外的错误处理能力和更加灵活的解析选项。只需将你的数据模型遵循**SmartCodable**协议，即可开始享受更加智能的数据解析体验。

### cocopods集成

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target 'MyApp' do
  pod 'SmartCodable'
end
```



### 字典类型的解码

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
guard let model = Model.deserialize(dict: dict) else { return }
```



### 数组类型解码

```
import SmartCodable

struct Model: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
let arr = [dict, dict]
guard let models = [Model].deserialize(array: arr) else { return }
```



###  序列化与反序列化

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



### 枚举的解码

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

让你的枚举遵守 **SmartCaseDefaultable** 协议，如果枚举解析失败，将使用defaultCase作为默认值。



### 解码Any

Codable是无法解码Any类型的，这样就意味着模型的属性类型可以为 **Any**，**[Any]**，**[String: Any]**。  这对解码的便利性造成了一定的困扰。

#### 官方的解决方案

对非原生类型字段，给它再生成一个struct，用原生类型来表述属性就行。

```
struct Block: Codable {
    let message: String
    let index: Int
    let transactions: [[String: Any]]
    let proof: String
    let previous_hash: String
}
```

改为： 

```
struct Transaction: Codable {
    let amount: Int
    let recipient: String
    let sender: String
}
 
struct Block: Codable {
    let message: String
    let index: Int
    let transactions: [Transaction]
    let proof: String
    let previous_hash: String
}
```

#### 使用泛型

如果情况允许，可以使用泛型来代替。

```
struct AboutAny<T: Codable>: SmartCodable {
    init() { }

    var dict1: [String: T] = [:]
    var dict2: [String: T] = [:]
}
guard let one = AboutAny<String>.deserialize(dict: dict) else { return }
```



#### 使用 SmartAny

**SmartAny** 是**SmartCodable** 提供了一种方案。SmartAny是枚举类型。

```
public enum SmartAny {
    case bool(Bool)
    case string(String)
    case double(Double)
    case cgFloat(CGFloat)
    case float(Float)
    case int(Int)
    case int8(Int8)
    case int16(Int16)
    case int32(Int32)
    case int64(Int64)
    case uInt(Int)
    case uInt8(UInt8)
    case uInt16(UInt16)
    case uInt32(UInt32)
    case uInt64(UInt64)    
    case dict([String: SmartAny])
    case array([SmartAny])
}

```

重写了`public init(from decoder: Decoder) throws`方法，将解析完成的数据包裹进SmartAny内。

```
extension SmartAny: Codable {
    // 实现 Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        
        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        }
        其他代码
        ......
    }
}
```

如果你要获取原始的数据，可以使用 **peel** 方法去壳。

```
extension Dictionary where Key == String, Value == SmartAny {
    /// 解析完成会被SmartAny包裹，使用该属性去壳。
    public var peel: [String: Any] {
        var temp: [String: Any] = [:]
        for (key, value) in self {
            temp.updateValue(value.peel, forKey: key)
        }
        return temp
    }
}

extension Array where Element == SmartAny {
    /// 解析完成会被SmartAny包裹，使用该属性去壳。
    public var peel: [Any] {
        var temp: [Any] = []
        
        temp = self.map({
            $0.peel
        })
        return temp
    }
}

extension SmartAny {
    /// 获取原本的值
    public var peel: Any {
        switch self {
        case .bool(let v):
            return v
            
        case .string(let v):
            return v
        
        // 其他代码
        ......
        }
    }
}
```

更多实现细节可以访问**SmartAny.swift** 文件。





## 解码策略 - SmartDecodingOption

```
public static func deserialize(json: String?, options: [SmartDecodingOption]? = nil) -> Self? 
```

options提供了四种解码选项，分别为：

```
    /// 用于在解码之前自动更改密钥值的策略
    case keyStrategy(KeyDecodingStrategy)
    
    /// 用于解码 “Date” 值的策略
    case dateStrategy(JSONDecoder.DateDecodingStrategy)
    
    /// 用于解码 “Data” 值的策略
    case dataStrategy(JSONDecoder.DataDecodingStrategy)
    
    /// 用于不符合json的浮点值(IEEE 754无穷大和NaN)的策略
    case floatStrategy(JSONDecoder.NonConformingFloatDecodingStrategy)
```



### SmartKeyDecodingStrategy

```
/// key解码策略
public enum SmartKeyDecodingStrategy {
    case useDefaultKeys
    case convertFromSnakeCase
    case custom([String: String])
}
```

* **useDefaultKeys：** 使用默认的解析映射方式。

* **convertFromSnakeCase：** 转驼峰的命名方式。会将本次解析的字段，全部转成驼峰命名。

* **custom：** 自定义的方式。key是数据中的字段名，value是模型中的属性名。

```
// 1. CodingKeys 映射
guard let feedOne = FeedOne.deserialize(json: json) else { return }

// 2.  使用keyDecodingStrategy的驼峰命名
guard let feedTwo = FeedTwo.deserialize(json: json, options: [.keyStrategy(.convertFromSnakeCase)]) else { return }



// 3. 使用keyDecodingStrategy的自定义策略
let option: SmartDecodingOption = .keyStrategy(.custom(["nick_name": "name"]))
guard let feedThree = FeedThree.deserialize(json: json, options: [option]) else { return }
```



### Date格式的解码

```
let json = """
{
   "birth": "2034-12-01 18:00:00"
}
"""
let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
let option: SmartDecodingOption = .dateStrategy(.formatted(dateFormatter))

guard let model = FeedOne.deserialize(json: json, options: [option]) else { return }
```



### Data类型的解码

```
let json = """
{
   "address": "aHR0cHM6Ly93d3cucWl4aW4uY29t"
}
"""

let option: SmartDecodingOption = .dataStrategy(.base64)
guard let model = FeedOne.deserialize(json: json, options: [option]) else { return }

if let data = model.address, let url = String(data: data, encoding: .utf8) {
    print(url)
    // https://www.qixin.com
}
```



## SmartCodable的兼容性

在使用系统的 **Codable** 解码的时候，遇到 **无键**，**值为null**， **值类型错误** 抛出异常导致解析失败。**SmartCodable** 底层默认对这三种解析错误进行了兼容。 

具体的实现逻辑可以查看 **Patcher.swift** 文件。

### 无键 & 值为null

这两种情况的数据，我称之为**摆烂数据**，这种数据无法拯救。

解析到 **无键 & 值为null** 的时候，SmartCodable会提供该字段类型的默认值进行解析填充（如果是可选类型，提供nil）。使解析顺利进行。

对这两份数据，解析到 **CompatibleTypes** 模型中

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

解析完成后，将使用该属性对应的数据类型的默认值进行填充。

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



### 值类型错误

这种情况的数据，我称之为**可拯救的数据**。例如： Model中定义的Bool类型，数据中返回的是Int类型的0或1，String类型的True/true/Yes/No等。

解析到 **值类型错误** 的时候，SmartCodable会尝试对数据值进行类型转换，如果转换成功，将使用该值。如果转换失败，将使用该属性对应的数据类型的默认值进行填充。

#### Bool类型的转换

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



#### String类型的转换

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



#### 其他更多类型

请查看 **TypePatcher.swift** 了解更多。



## 调试日志

SmartCodable鼓励从根本上解决解析中的问题，即：不需要用到SmartCodable的兼容逻辑。 如果出现解析兼容的情况，修改Model中属性的定义，或要求数据方进行修正。为了更方便的定位问题，SmartCodable提供了便捷的解析错误日志。

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

你可以通过SmartConfig 调整日志的相关设置。



##### 如何理解数据节点？

![数据节点](https://github.com/intsig171/SmartCodable/assets/87351449/255b8244-d121-48f2-9f35-7d28c9286921)


右侧的数据是数组类型。注意标红的内容，由外到里对照查看。

* Index 0:  数组的下标为0的元素。

* sampleFive： 下标为0的元素对应的是字典，即字典key为sampleFive对应的值（是一个数组）。

* Index 1：数组的下标为1的元素.

* sampleOne：字典中key为sampleOne对应的值。

* string：字典中key为sring对应的值。

  





## 四. SamrtCodable的缺点

### 1. 可选模型属性

```
struct Feed: SmartCodable {
    var one: FeedOne?
}
struct FeedOne: SmartCodable {
    var name: String = ""
}
```

如有模型中的属性是嵌套的模型属性，遇到类型不匹配的情况，Codable无法解析抛出异常，这种情况的异常，SmartCodale将无法兼容。

此时您有两种选择：

* 将Feed中one这个属性设置为非可选的。 SmartCodable 将正常工作。
* 将该属性使用 **@SmartOptional** 属性包装器修饰。

```
struct Feed: SmartCodable {
    @SmartOptional var one: FeedOne?
}

class FeedOne: SmartCodable {
    var name: String = ""
    required init() { }
}
```

**这是一个不得已的实现方案**:

为了做解码失败的兼容，我们重写了 **KeyedEncodingContainer** 的  **decode** 和 **decodeIfPresent** 方法。

需要注意的是：decodeIfPresent底层的实现仍是使用的 **decode**。

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

KeyedEncodingContainer容器是用结构体实现的。 重写了结构体的方法之后，没办法再调用父方法。

1. 这种情况下，如果再重写 `public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T?` 方法，就会导致方法的循环调用。
2. 使用SmartOptional属性包装器修饰可选属性，被修饰后会产生一个新的类型，对此类型解码就不会走decodeIfPresent，而是会走decode方法。

#### 使用SmartOptional的三个限制条件

* 必须遵循SmartDecodable协议

* 必须是可选属性

  如果不是可选属性，就没必要使用SmartOptional。

* 必须是class类型

  如果模型是Struct，是值类型。在执行 **didFinishMapping** 的时候，无法初始化被属性包装器修饰的属性，进而无法有效的执行解码完成之后的值修改。

  

**如果你有更好的方案，可以提issue。**





### 2. 模型中设置的默认值无效

Codable在进行解码的时候，是无法知道这个属性的。所以在decode的时候，如果解析失败，使用默认值进行填充时，拿不到这个默认值。再处理解码兼容时，只能自己生成一个对应类型的默认值填充。

**如果你有更好的方案，可以提issue。**





## 进一步了解

我们提供了详细的示例工程，可以下载工程代码查看。

![](https://camo.githubusercontent.com/60d43befa03e46e0dc0e6c284f23670bbeb1c91e4977409f488b1abc527d6a8a/68747470733a2f2f70392d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f66383832663864626530366634343237613365343438623462363930333962627e74706c762d6b3375316662706663702d6a6a2d6d61726b3a303a303a303a303a7137352e696d616765233f773d34343026683d38383826733d31323132363226653d706e6726623d666566656665)



### 了解更多关于Codable & SmartCodable

这是Swift数据解析方案的系列文章：

[Swift数据解析(第一篇) - 技术选型](https://juejin.cn/post/7288517000581070902)

[Swift数据解析(第二篇) - Codable 上](https://juejin.cn/post/7288517000581087286)

[Swift数据解析(第二篇) - Codable 下](https://juejin.cn/post/7288517000581120054)

[Swift数据解析(第三篇) - Codable源码学习](https://juejin.cn/post/7288504491506090023)

[Swift数据解析(第四篇) - SmartCodable 上](https://juejin.cn/post/7288513881735151670)

[Swift数据解析(第四篇) - SmartCodable 下](https://juejin.cn/post/7288517000581169206)



### 联系我们

![](https://private-user-images.githubusercontent.com/87351449/291540056-0bfd9e7b-cea3-4cb1-b4b6-6dbe8dd0a97a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQxODQ4NzEsIm5iZiI6MTcwNDE4NDU3MSwicGF0aCI6Ii84NzM1MTQ0OS8yOTE1NDAwNTYtMGJmZDllN2ItY2VhMy00Y2IxLWI0YjYtNmRiZThkZDBhOTdhLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDAxMDIlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMTAyVDA4MzYxMVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTYzNDhmNWRmZmNiYzNiYTFkMjI2YzYzODQ3MjA0MTc1MThlNTI2MDc0MTU3M2IzODNlMjJiOTg4MzU5NmJjMjUmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.HG5O1D6W4afDJ_MnWJxlGqKzG5gUtcMoNy_zGy0Yuqo)



## 加入我们

**SmartCodable** 是一个开源项目，我们欢迎所有对提高数据解析性能和健壮性感兴趣的开发者加入。无论是使用反馈、功能建议还是代码贡献，你的参与都将极大地推动 **SmartCodable** 项目的发展。





