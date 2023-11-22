这是Swift数据解析方案的系列文章：

[Swift数据解析(第一篇) - 技术选型](https://juejin.cn/post/7288517000581070902)

[Swift数据解析(第二篇) - Codable 上](https://juejin.cn/post/7288517000581087286)

[Swift数据解析(第二篇) - Codable 下](https://juejin.cn/post/7288517000581120054)

[Swift数据解析(第三篇) - Codable源码学习](https://juejin.cn/post/7288504491506090023)

[Swift数据解析(第四篇) - SmartCodable 上](https://juejin.cn/post/7288513881735151670)

[Swift数据解析(第四篇) - SmartCodable 下](https://juejin.cn/post/7288517000581169206)


使用**Codable** 协议 进行 **decode** 时候，遇到以下三种情况就会失败。并且只有一个属性解析失败时就抛出异常，导致整个解析失败：

-   类型键不存在
-   类型键不匹配
-   数据值是null

**SmartCodable** 旨在兼容处理 **Codable** 解码抛出的异常，使解析顺利进行下去。

**SmartCodable** 提供穷尽了各种异常场景验证兼容性，均成功兼容。

[SmartCodable的github地址](https://github.com/intsig171/SmartCodable)


![示例.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f882f8dbe06f4427a3e448b4b69039bb~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=440&h=888&s=121262&e=png&b=fefefe)




## 环境要求
Swift 5.0+

## 安装
Add the following line to your `Podfile`:

```
$ pod 'SmartCodable'
```

Then, run the following command:

```
$ pod install
```

## 一. 使用SmartCodable

### 字典类型的解码

```
 import SmartCodable
 ​
 struct SimpleSmartCodableModel: SmartCodable {
    var name: String = ""
 }
 ​
 let dict: [String: String] = ["name": "xiaoming"]
 guard let model = SimpleSmartCodableModel.deserialize(dict: dict) else { return }
 print(model.name)
```

### 数组类型的解码

```
 import SmartCodable
 ​
 struct SimpleSmartCodableModel: SmartCodable {
    var name: String = ""
 }
 ​
 let dict: [String: String] = ["name": "xiaoming"]
 let arr = [dict, dict]
 guard let models = [SimpleSmartCodableModel].deserialize(array: arr) else { return }
 print(models)
```

### 序列化与反序列化

```
 // 字典转模型
 guard let xiaoMing = JsonToModel.deserialize(dict: dict) else { return }
 ​
 // 模型转字典
 let studentDict = xiaoMing.toDictionary() ?? [:]
 ​
 // 模型转json字符串
 let json1 = xiaoMing.toJSONString(prettyPrint: true) ?? ""
 ​
 // json字符串转模型
 guard let xiaoMing2 = JsonToModel.deserialize(json: json1) else { return }
```

## 二. SmartCoable 解析增强

### 解析完成的回调

```
 class FinishMappingSingle: SmartDecodable {
 ​
    var name: String = ""
    var age: Int = 0
    var desc: String = ""
     
    required init() { }
     
    func didFinishMapping() {
                 
        if name.isEmpty {
            desc = "(age)岁的" + "人"
        } else {
            desc = "(age)岁的" + name
        }
    }
 }
```

当结束decode之后，会通过该方法回调。提供该类在解析完成进一步对值处理的能力。

### 字段重命名

```
 let json = """
{
  "nick_name": "小明"
}
"""

// 1. CodingKeys 映射
guard let feedOne = FeedOne.deserialize(json: json) else { return }
print("feedOne.name = \(feedOne.name)")

// 2.  使用keyDecodingStrategy的驼峰命名
guard let feedTwo = FeedTwo.deserialize(json: json, strategy: .convertFromSnakeCase) else { return }
print("feedTwo.nickName = \(feedTwo.nickName)")

// 3. 使用keyDecodingStrategy的自定义策略
guard let feedThree = FeedThree.deserialize(json: json, strategy: .custom(["nick_name": "name"])) else { return }
print("feedThree.name = \(feedThree.name)")

struct FeedOne: SmartCodable {
    var name: String = ""
    enum CodingKeys: String, CodingKey {
        case name = "nick_name"
    }
}

struct FeedTwo: SmartCodable {
    var nickName: String = ""
}

struct FeedThree: SmartCodable {
    var name: String = ""
}
```

通过实现mapping方法，返回解码key的映射关系。

## 三. SmartCodable的兼容性

### 兼容策略

**smartCodable** 的兼容性是从两方面设计的：

-   类型兼容：如果值对应的真实类型和属性的类型不匹配时，尝试对值进行类型转换，如果可以转换成功，就使用转换之后值填充。
-   默认值兼容：当解析失败的时候，会提供属性类型对应的默认值进行填充。

#### 1. 类型转换兼容策略

```
 /// 类型兼容器，负责尝试兼容类型不匹配，只兼容数据有意义的情况（可以合理的进行类型转换的）。
 struct TypeCumulator<T: Decodable> {
    static func compatible(originValue: Any?) -> T? {
        if let value = originValue {
            
            switch T.self {
            case is Bool.Type:
                let smart = compatibleBoolType(value: value)
                return smart as? T

            case is String.Type:
                let smart = compatibleStringType(value: value)
                return smart as? T

            case is Int.Type:
                let smart = compatibleIntType(value: value)
                return smart as? T

            case is Float.Type:
                let smart = compatibleFloatType(value: value)
                return smart as? T
                
            case is CGFloat.Type:
                let smart = compatibleCGFloatType(value: value)
                return smart as? T

            case is Double.Type:
                let smart = compatibleDoubleType(value: value)
                return smart as? T
            default:
                break
            }
        }
        return nil
    }
 ​
     
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
            case "0", "NO", "No", "no", "FALSE", "False", "false":
                return false
            default:
                return nil
            }
        default:
            return nil
        }
    }
     
     
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
     
    /// 兼容Int类型的值
    static func compatibleIntType(value: Any) -> Int? {
        if let v = value as? String, let intValue = Int(v) {
            return intValue
        }
        return nil
    }
     
    /// 兼容 Float 类型的值
    static func compatibleFloatType(value: Any) -> Float? {
        if let v = value as? String {
            return v.toFloat()
        }
        return nil
    }
     
    /// 兼容 double 类型的值
    static func compatibleDoubleType(value: Any) -> Double? {
        if let v = value as? String {
            return v.toDouble()
        }
        return nil
    }
     
    /// 兼容 CGFloat 类型的值
    static func compatibleCGFloatType(value: Any) -> CGFloat? {
        if let v = value as? String {
            return v.toCGFloat()
        }
        return nil
    }
 }
```

#### 2. 默认值兼容

```
 /// 默认值兼容器
 struct DefaultValuePatcher<T: Decodable> {
     
    /// 生产对应类型的默认值
    static func makeDefaultValue() throws -> T? {
 ​
        if let arr = [] as? T {
            return arr
             
        } else if let dict = [:] as? T {
            return dict
             
        } else if let value = "" as? T {
            return value
        } else if let value = false as? T {
            return value
        } else if let value = Date.defaultValue as? T {
            return value
        } else if let value = Data.defaultValue as? T {
            return value
        } else if let value = Decimal.defaultValue as? T {
            return value
                         
        } else if let value = Double(0.0) as? T {
            return value
        } else if let value = Float(0.0) as? T {
            return value
        } else if let value = CGFloat(0.0) as? T {
            return value
             
        } else if let value = Int(0) as? T {
            return value
        } else if let value = Int8(0) as? T {
            return value
        } else if let value = Int16(0) as? T {
            return value
        } else if let value = Int32(0) as? T {
            return value
        } else if let value = Int64(0) as? T {
            return value
                         
        } else if let value = UInt(0) as? T {
            return value
        } else if let value = UInt8(0) as? T {
            return value
        } else if let value = UInt16(0) as? T {
            return value
        } else if let value = UInt32(0) as? T {
            return value
        } else if let value = UInt64(0) as? T {
            return value
        } else {
            /// 判断此时的类型是否实现了SmartCodable， 如果是就说明是自定义的结构体或类。
            if let object = T.self as? SmartDecodable.Type {
                return object.init() as? T
            } else {
                SmartLog.logDebug("(Self.self)提供默认值失败, 发现未知类型，无法提供默热值。如有遇到请反馈，感谢")
                return nil
            }
        }
    }
 }
```

### 不同场景的兼容方案

#### 1. 键缺失的兼容

-   非可选属性：使用默认值兼容方案。
-   可选属性：使用nil填充。

详见demo中 **CompatibleKeylessViewController** 演示。

#### 2. 值类型不匹配

-   非可选属性：先使用类型转换兼容，兼容失败再使用默认值兼容方案。
-   可选属性：先使用类型转换兼容，兼容失败使用nil填充。

详见demo中 **CompatibleTypeMismatchViewController** 演示。

#### 3. 空对象的兼容

-   非可选属性：使用默认值兼容方案。
-   可选属性：使用nil填充。

详见demo中 **CompatibleEmptyObjectViewController** 演示。

#### 4. null值的兼容

-   属性为非可选，使用属性类型对应的默认值进行填充。
-   属性为可选，使用nil填充。

详见demo中 **CompatibleNullViewController** 演示。

#### 5. enum的兼容

枚举的兼容较为特殊，提供了SmartCaseDefaultable协议，如果解码失败，使用协议属性defaultCase兼容。

```
 struct CompatibleEnum: SmartCodable {
 ​
    init() { }
    var enumTest: TestEnum = .a
 ​
    enum TestEnum: String, SmartCaseDefaultable {
        static var defaultCase: TestEnum = .a
 ​
        case a
        case b
        case hello = "c"
    }
 }
```

详见demo中 **CompatibleEnumViewController** 演示。

#### 6. 浮点数的兼容

-   非可选属性：先使用类型转换兼容，兼容失败再使用默认值兼容方案。
-   可选属性：先使用类型转换兼容，兼容失败使用nil填充。

详见demo中 **CompatibleFloatViewController** 演示。

#### 7. Bool的兼容

-   非可选属性：先使用类型转换兼容，兼容失败再使用默认值兼容方案。
-   可选属性：先使用类型转换兼容，兼容失败使用nil填充。

详见demo中 **CompatibleBoolViewController** 演示。

#### 8. String的兼容

-   非可选属性：先使用类型转换兼容，兼容失败再使用默认值兼容方案。
-   可选属性：先使用类型转换兼容，兼容失败使用nil填充。

详见demo中 **CompatibleStringViewController** 演示。

#### 9. Int的兼容

-   非可选属性：先使用类型转换兼容，兼容失败再使用默认值兼容方案。
-   可选属性：先使用类型转换兼容，兼容失败使用nil填充。

详见demo中 **CompatibleIntViewController** 演示。

#### 10. class的兼容

-   非可选属性：使用默认值兼容方案。
-   可选属性：使用nil填充。

详见demo中 **CompatibleClassViewController** 演示。

## 四. 调试日志

经过我们的兼容，解析将不会出现问题，但是这是这掩盖了问题，并没有从根本上解决问题。如果开启了调试日志，将提供辅助信息，帮助定位问题。

-   错误类型: 错误的类型信息
-   模型名称：发生错误的模型名出
-   数据节点：发生错误时，数据的解码路径。
-   属性信息：发生错误的字段名。
-   错误原因: 错误的具体原因。

```
 ================ [SmartLog Error] ================
 错误类型: '找不到键的错误' 
 模型名称：Array<Class> 
 数据节点：Index 0 → students → Index 0
 属性信息：（名称）more
 错误原因: No value associated with key CodingKeys(stringValue: "more", intValue: nil) ("more").
 ==================================================
 ​
 ================ [SmartLog Error] ================
 错误类型: '值类型不匹配的错误' 
 模型名称：DecodeErrorPrint 
 数据节点：a
 属性信息：（类型）Bool （名称）a
 错误原因: Expected to decode Bool but found a string/data instead.
 ==================================================
 ​
 ​
 ================ [SmartLog Error] ================
 错误类型: '找不到值的错误' 
 模型名称：DecodeErrorPrint 
 数据节点：c
 属性信息：（类型）Bool （名称）c
 错误原因: c 在json中对应的值是null
 ==================================================
```

你可以通过SmartConfig.debugMode 调整日志的打印等级。

## 五. SamrtCodable的缺点

其实算是Codable的缺点。

### 1. 可选模型属性

如果要解析嵌套结构，该模型属性要设置为可选，需要使用 **@SmartOptional** 属性包装器修饰。

```
 struct Firend: SmartDecodable {
    var age: Int?
    var name: String = ""
    @SmartOptional var location: Location?
    var hobby: Hobby = Hobby()
 }
 ​
 class Location: SmartDecodable {
    var pronince: String = ""
    var city: String = ""
     
    required init() { }
 }
 ​
 struct Hobby: SmartDecodable {
    var name: String = ""
    init() {
        name = ""
    }
 }
```
**Firend 的 location属性** 是一个遵守了 **SmartDecodable** 的模型。如果设置为可选属性需要使用 **@SmartOptional** 属性包装器修饰。

#### 使用SmartOptional的限制

SmartOptional修饰的对象必须满足一下三个要求：

1.  必须遵循SmartDecodable协议

    常规的属性（Bool/String/Int等）没有使用 **@SmartOptional** 属性包装器的必要，因此做了该限制。

0.  必须是可选属性

    非可选的属性没有使用 **@SmartOptional** 属性包装器的必要，因此做了该限制。

0.  必须是class类型

    通过 `didFinishMapping` 修改该属性的值的情况下，借用 **class** 的引用类型的特性，达到修改的目的。可以查看 **acceptChangesAfterMappingCompleted** 该方法的实现。

#### 为什么这么做？

这是一个不得已的实现方案。

1.  为了做解码失败的兼容，我们重写了KeyedEncodingContainer的decode和decodeIfPresent方法，这两个类型的方法均会走到兜底的smartDecode方法中。

该方法最终使用了public func decodeIfPresent<T>(_ *type: T.Type, forKey key: K) throws -> T? 实现了decode能力。*

2.  KeyedEncodingContainer容器是用结构体实现的。 重写了结构体的方法之后，没办法再调用父方法。
3.  这种情况下，如果再重写public func decodeIfPresent *<T>* (*_ type: T.Type, forKey key: K) throws -> T?方法，就会导致方法的循环调用。
4.  我们使用SmartOptional属性包装器修饰可选的属性，被修饰后会产生一个新的类型，对此类型解码就不会走decodeIfPresent，而是会走decode方法。

### 2. Any无法使用

Any无法实现Codable，所以在使用Codable的时候，一切跟Any有关的均不允许，比如[String：Any]，[Any]。
```
struct Feed: SmartCodable {

    /// Type 'Feed' does not conform to protocol 'Decodable'
    var dict: [String: Any] = [:]
}
```

可以通过指定类型，比如[Sting: String], 放弃Any的使用。

或者通过范型，比如

```
 struct AboutAny<T: Codable>: SmartCodable {
    init() { }
 ​
    var dict1: [String: T] = [:]
    var dict2: [String: T] = [:]
 }
```

### 3. 模型中设置的默认值无效

Codable在进行解码的时候，是无法知道这个属性的。所以在decode的时候，如果解析失败，使用默认值进行填充时，拿不到这个默认值。再处理解码兼容时，只能自己生成一个对应类型的默认值填充。
```
struct Feed: SmartCodable {
    /// 如果解码失败，会被填充 ““，导致defalut value被替换掉。
    var name: String = "defalut value"
}
