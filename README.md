使用**Codable** 协议 进行 **decode** 时候，遇到以下三种情况就会失败。导致整个解析失败：【类型键不存在】，【类型键不匹配】，【数据值是null】。

**SmartCodable** 在 **Codable**的解析能力上，对解析失败的情况进行兼容，使解析顺利进行下去。所以您可以放心使用，

并且 **SmartCodable**  提供了 **Codable** 无法对Any类型解析的问题。



### 如何使用

```
pod 'SmartCodable'
```



## 一. 使用SmartCodable

### 字典类型的解码

```
import SmartCodable

struct SimpleSmartCodableModel: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
guard let model = SimpleSmartCodableModel.deserialize(dict: dict) else { return }
print(model.name)
```

### 数组类型的解码

```
import SmartCodable

struct SimpleSmartCodableModel: SmartCodable {
    var name: String = ""
}

let dict: [String: String] = ["name": "xiaoming"]
let arr = [dict, dict]
guard let models = [SimpleSmartCodableModel].deserialize(array: arr) else { return }
print(models)
```



### 序列化与反序列化

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
class FinishMappingSingle: SmartDecodable {

    var name: String = ""
    var age: Int = 0
    var desc: String = ""
    required init() { }
    
    func didFinishMapping() {    
        if name.isEmpty {
            desc = "\(age)岁的" + "人"
        } else {
            desc = "\(age)岁的" + name
        }
    }
}
```

当结束decode之后，会通过该方法回调通知。提供该类在解析完成进一步对值处理的能力。



## 二 SmartCodable的解码策略

### 1. 解码时字段重命名

提供了三种字段重命名的选择：

```
/// key解码策略
public enum SmartKeyDecodingStrategy {
    case useDefaultKeys
    case convertFromSnakeCase
    case custom([String: String])
}
```

* useDefaultKeys：使用默认的解析映射方式。
* convertFromSnakeCase： 转驼峰的命名方式。会将本次解析的字段，全部转成驼峰命名。
* custom： 自定义的方式。key： 数据中的字段名，value：模型中的属性名。

```
// 1. CodingKeys 映射
guard let feedOne = FeedOne.deserialize(json: json) else { return }
print("feedOne.name = \(feedOne.name)")

// 2.  使用keyDecodingStrategy的驼峰命名
guard let feedTwo = FeedTwo.deserialize(json: json, options: [.keyStrategy(.convertFromSnakeCase)]) else { return }
print("feedTwo.nickName = \(feedTwo.nickName)")


// 3. 使用keyDecodingStrategy的自定义策略
let option: SmartDecodingOption = .keyStrategy(.custom(["nick_name": "name"]))
guard let feedThree = FeedThree.deserialize(json: json, options: [option]) else { return }
print("feedThree.name = \(feedThree.name)")
```



### 2. Date的解码

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



### 3. Data类型

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



## 三. SmartCodable对解析错误进行兼容

**smartCodable** 的兼容性是从两方面设计的：

* 类型兼容：如果值对应的真实类型和属性的类型不匹配时，尝试对值进行类型转换，如果可以转换成功，就使用转换之后值填充。
* 默认值兼容：当解析失败的时候，会提供属性类型对应的默认值进行填充。



**CompatibleTypes** Model中假设了各种类型的属性，分别针对 **无键**，**值为null**， **值类型错误** 进行演示。

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



### 兼容策略：验证 [无键] 的兼容性

```
var json: String {
   """
   {
   }
   """
}

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



### 兼容策略：验证 [值为null] 的兼容性

```
let json: String {
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
             "z": null,
           }
           """
}

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





### 兼容策略：验证 [值类型错误] 的兼容性

```
var json: String {
           """
           {
           "a": [],
           "b": [],
           "c": [],
           "d": [],
           "e": [],
           "f": [],
            "g": [],
            "h": [],
            "i": [],
            "j": [],
            "k": [],
            "l": [],
           
            "v": 123,
            "w": 123,
            "x": 123,
            "y": 123,
            "z": 123,
          }
         """
}

guard let person = OptionalCompatibleTypes.deserialize(json: json) else { return }

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





### SmartCodable对特殊类型的兼容

###  枚举的兼容

枚举的兼容较为特殊，SmartCodable要求枚举遵循SmartCaseDefaultable协议，如果枚举解析失败，将使用提供的defaultCase值。

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



### 浮点数的兼容

浮点类型的解析可能遇到 **Nan** **inf**等情况，SmartCodable也做兼容。

```
struct CompatibleFloat: SmartCodable {
    var floatValue: Float = 0
    var floatValue1: Float = 0
    var floatValue2: Float = 0
    var floatValue3: Float = 0
    var floatValue4: Float?


    var cgfloatValue: CGFloat = 0
    var doubleValue: Double = 0
    init() { }
}

let json = """
{
  "floatValue": "NaN",
  "floatValue1": "123",
  "floatValue2": "abc",
  "cgfloatValue": "nan",
  "doubleValue": "nan",
}
"""
guard let model = CompatibleFloat.deserialize(json: json) else { return }
print(model.floatValue)
print(model.floatValue1)
print(model.floatValue2)
print(model.floatValue3)
print(model.floatValue4 as Any)

print(model.cgfloatValue)
print(model.doubleValue)

/**
 0.0
 123.0
 0.0
 nil
 0.0
 0.0
 */
```



### Bool的兼容

```
struct BoolAdaptive: SmartCodable {
    init() { }
    
    var a: Bool?
    var b: Bool = false
    var c: Bool = false
    var d: Bool = false

    var e: Bool = false
    var f: Bool = false
    var g: Bool = false

    var h: Bool = false
    var i: Bool = false
    var j: Bool = false
    var k: Bool = false
    var l: Bool = false
    var m: Bool = false
    var n: Bool = false
    var o: Bool = false
    var p: Bool = false
    var q: Bool = false
    var r: Bool?
}

let dict = [
    "a": 0,
    "b": 1,
    "c": "0",
    "d": "1",
    
    "e": "YES",
    "f": "Yes",
    "g": "yes",
    "h": "True",
    "i": "true",
    "j": "TRUE",
    
    "k": "NO",
    "l": "No",
    "m": "no",
    "n": "FALSE",
    "o": "False",
    "p": "false",
    "q": "ABC",
    "r": 234,
] as [String : Any]

guard let adaptive = BoolAdaptive.deserialize(dict: dict else { return }
/**
 "属性：a 的类型是 Bool， 其值为 false"
 "属性：b 的类型是 Bool， 其值为 true"
 "属性：c 的类型是 Bool， 其值为 false"
 "属性：d 的类型是 Bool， 其值为 true"


 "属性：e 的类型是 Bool， 其值为 true"
 "属性：f 的类型是 Bool， 其值为 true"
 "属性：g 的类型是 Bool， 其值为 true"
 "属性：h 的类型是 Bool， 其值为 true"
 "属性：i 的类型是 Bool， 其值为 true"
 "属性：j 的类型是 Bool， 其值为 true"


 "属性：k 的类型是 Bool， 其值为 false"
 "属性：l 的类型是 Bool， 其值为 false"
 "属性：m 的类型是 Bool， 其值为 false"
 "属性：n 的类型是 Bool， 其值为 false"
 "属性：o 的类型是 Bool， 其值为 false"
 "属性：p 的类型是 Bool， 其值为 false"
 "属性：q 的类型是 Bool， 其值为 false"
 "属性：r 的类型是 Bool， 其值为 false"
 */
```

SmartCodable将一些有意义的值类型错误的情况做了兼容。

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



## 关于Any

**Codable** 无法对 **Any** 类型进行，原因是 **Codable** 无法识别 **Any** 类型是否遵守了 **Codable** 协议。

**SmartCodable** 提供了**SmartAny** 类型，用来代替 **Any**，解决无法解析的问题。

您需要注意的是： 解析完成，**SmartAny** 会对原始数据包装一次，使用的时候，调用 **peel** 获取对应的原始数据。

```
struct AnyModel: SmartCodable {
    var name: SmartAny?
    var age: SmartAny = .int(0)
    var dict: [String: SmartAny] = [:]
    var arr: [SmartAny] = []
}

let inDict = [
    "key1": 1,
    "key2": "two",
    "key3": ["key": "1"],
    "key4": [1, 2, 3, 4]
] as [String : Any]

let arr = [inDict]

let dict = [
    "name": "xiao ming",
    "age": 20,
    "dict": inDict,
    "arr": arr
] as [String : Any]


guard let model = AnyModel.deserialize(dict: dict) else { return }
print(model.name?.peel ?? 0)
print(model.age.peel)
print(model.dict.peel)
print(model.arr.peel)

/**
xiao ming
20.0
["key4": [1.0, 2.0, 3.0, 4.0], "key1": 1.0, "key2": "two", "key3": ["key": "1"]]
[["key4": [1.0, 2.0, 3.0, 4.0], "key1": 1.0, "key2": "two", "key3": ["key": "1"]]]
*/
```





## 五. 调试日志

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

![image](https://github.com/intsig171/SmartCodable/assets/87351449/26f05336-c453-4769-a830-a20408427381)

右侧的数据是数组类型。注意标红的内容，由外到里对照查看。

* Index 0:  数组的下标为0的元素。

* sampleFive： 下标为0的元素对应的是字典，即字典key为sampleFive对应的值（是一个数组）。

* Index 1：数组的下标为1的元素.

* sampleOne：字典中key为sampleOne对应的值。

* string：字典中key为sring对应的值。

  





## 六. SamrtCodable的缺点

其实算是Codable的缺点。

### 1. 可选模型属性

```
let dict: [String: Any] = [
    "one": 123
]

let model = Feed.deserialize(dict: dict)
print(model.one as Any)

struct Feed: SmartCodable {
    var one: FeedOne?
}

struct FeedOne: SmartCodable {
    var name: String = ""
}
```

如有模型中的属性是另外一个模型，遇到类型不匹配的问题，将导致解析失败，SmartCodale将不会进行兼容。此时您有两种选择：

* 将Feed中one这个属性设置为非可选的: `var one = FeedOne()` , SmartCodable 将正常工作。w
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



#### 使用SmartOptional的限制

 SmartOptional修饰的对象必须满足一下三个要求：

1. 必须遵循SmartDecodable协议。

2. 必须是可选属性

3. 必须是class类型

**这是一个不得已的实现方案**:

1. 为了做解码失败的兼容，我们重写了KeyedEncodingContainer的decode和decodeIfPresent方法，这两个类型的方法均会走到兜底的smartDecode方法中。  该方法最终使用了`public func decodeIfPresent<T>(_ *type: T.Type, forKey key: K) throws -> T? `实现了decode能力。

2. KeyedEncodingContainer容器是用结构体实现的。 重写了结构体的方法之后，没办法再调用父方法。

3. 这种情况下，如果再重写public func decodeIfPresent*<T>*(*_ type: T.Type, forKey key: K) throws -> T?方法，就会导致方法的循环调用。

4. 我们使用SmartOptional属性包装器修饰可选的属性，被修饰后会产生一个新的类型，对此类型解码就不会走decodeIfPresent，而是会走decode方法。

   



### 2. 模型中设置的默认值无效

Codable在进行解码的时候，是无法知道这个属性的。所以在decode的时候，如果解析失败，使用默认值进行填充时，拿不到这个默认值。再处理解码兼容时，只能自己生成一个对应类型的默认值填充。



## 五. 其他

### 1.进一步了解SmartCoable

如果还想进一步了解，请下载改项目，我们提供了详细的演示用例。

![演示样例](https://camo.githubusercontent.com/60d43befa03e46e0dc0e6c284f23670bbeb1c91e4977409f488b1abc527d6a8a/68747470733a2f2f70392d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f66383832663864626530366634343237613365343438623462363930333962627e74706c762d6b3375316662706663702d6a6a2d6d61726b3a303a303a303a303a7137352e696d616765233f773d34343026683d38383826733d31323132363226653d706e6726623d666566656665)

### 了解更多关于Codable & SmartCodable

这是Swift数据解析方案的系列文章：

[Swift数据解析(第一篇) - 技术选型](https://juejin.cn/post/7288517000581070902)

[Swift数据解析(第二篇) - Codable 上](https://juejin.cn/post/7288517000581087286)

[Swift数据解析(第二篇) - Codable 下](https://juejin.cn/post/7288517000581120054)

[Swift数据解析(第三篇) - Codable源码学习](https://juejin.cn/post/7288504491506090023)

[Swift数据解析(第四篇) - SmartCodable 上](https://juejin.cn/post/7288513881735151670)

[Swift数据解析(第四篇) - SmartCodable 下](https://juejin.cn/post/7288517000581169206) 
