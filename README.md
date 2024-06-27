<p align="center">
<img src="https://github.com/intsig171/SmartCodable/assets/87351449/89de27ac-1760-42ee-a680-4811a043c8b1" alt="SmartCodable" title="SmartCodable" width="500"/>
</p>

<h1 align="center">SmartCodable - Swift data decoding & encoding</h1>



[![Swift Package Manager](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/cocoapods/p/ExCodable.svg)](#readme)
[![Build and Test](https://github.com/iwill/ExCodable/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/iwill/ExCodable/actions/workflows/build-and-test.yml)
[![GitHub Releases (latest SemVer)](https://img.shields.io/github/v/release/iwill/ExCodable.svg?sort=semver)](https://github.com/iwill/ExCodable/releases)
[![LICENSE](https://img.shields.io/github/license/iwill/ExCodable.svg)](https://github.com/iwill/ExCodable/blob/master/LICENSE)


**SmartCodable** is a data parsing library based on Swift's **Codable** protocol, designed to provide more powerful and flexible parsing capabilities. By optimizing and rewriting the standard features of **Codable**, **SmartCodable** effectively solves common problems in the traditional parsing process and improves the fault tolerance and flexibility of parsing.

**SmartCodable** 是一个基于Swift的**Codable**协议的数据解析库，旨在提供更为强大和灵活的解析能力。通过优化和重写**Codable**的标准功能，**SmartCodable** 有效地解决了传统解析过程中的常见问题，并提高了解析的容错性和灵活性。

```
struct Model: SmartCodable {
    var age: Int?
    var name: String = ""
}

let model = Model.deserialize(from: json)
```



## Use SmartCodable

### Installation - cocopods 

Add the following line to your `Podfile`:

```
pod 'SmartCodable'
```

Then, run the following command:

```
$ pod install
```

### Installation - Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/intsig171/SmartCodable.git`



### Usages

```
import SmartCodable

struct Model: SmartCodable {
    var string: String?
    var date: Date?
    var subModel: SubModel?
    
    @SmartAny
    var dict: [String: Any]?
    
    @IgnoredKey
    var ignoreKey: String?
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.date <--- "nowDate"
        ]
    }
    
    static func mappingForValue() -> [SmartValueTransformer]? {
        [
            CodingKeys.date <--- SmartDateTransformer(),
        ]
    }
    
    func didFinishMapping() {
        // do something
    }
}

```

If you don't know how to use it, check it out.

如果你不知道如何使用，请查看它。

 [👉 How to use SmartCodable?](https://github.com/intsig171/SmartCodable/blob/develop/Document/README/Usages.md)



## SmarCodable Test

 [👉 To learn more about how SmartCodable is tested, click here](https://github.com/intsig171/SmartCodable/blob/main/Document/README/HowToTest.md)



## Debug log

**SmartLog Error** indicates that **SmartCodable** encountered a resolution problem and executed compatibility logic. This does not mean that the analysis failed.

SmartCodable encourages the root of the resolution problem: it does not require SmartCodable compatibility logic.

出现 **SmartLog Error** 日志代表着 **SmartCodable** 遇到了解析问题，执行了兼容逻辑。 并不代表着本次解析失败。

SmartCodable鼓励从根本上解决解析中的问题，即：不需要用到SmartCodable的兼容逻辑。 

```
 ========================  [Smart Decoding Log]  ========================
 Family 👈🏻 👀
    |- name    : Expected to decode String but found an array instead.
    |- location: Expected to decode String but found an array instead.
    |- date    : Expected to decode Date but found an array instead.
    |> father: Father
       |- name: Expected String value but found null instead.
       |- age : Expected to decode Int but found a string/data instead.
       |> dog: Dog
          |- hobby: Expected to decode String but found a number instead.
    |> sons: [Son]
       |- [Index 0] hobby: Expected to decode String but found a number instead.
       |- [Index 0] age  : Expected to decode Int but found a string/data instead.
       |- [Index 1] age  : Expected to decode Int but found an array instead.
 =========================================================================
```





## Codable vs HandyJSON 

If you are using HandyJSON and would like to replace it, follow this link.

如果你正在使用HandyJSON，并希望替换掉它，请关注该链接。

 [👉 SmartCodable - Compare With HandyJSON](https://github.com/intsig171/SmartCodable/blob/develop/Document/README/CompareWithHandyJSON.md)

| 序号 | 🎯 特性                        | 💬 特性说明 💬                                                 | SmartCodable | HandyJSON |
| ---- | ----------------------------- | ------------------------------------------------------------ | ------------ | --------- |
| 1    | **强大的兼容性**              | 完美兼容：**字段缺失** & **字段值为nul** & **字段类型错误**  | ✅            | ✅         |
| 2    | **类型自适应**                | 如JSON中是一个Int，但对应Model是String字段，会自动完成转化   | ✅            | ✅         |
| 3    | **解析Any**                   | 支持解析 **[Any], [String: Any]** 等类型                     | ✅            | ✅         |
| 4    | **解码回调**                  | 支持Model解码完成的回调，即：**didFinishingMapping**         | ✅            | ✅         |
| 5    | **属性初始化值填充**          | 当解析失败时，支持使用初始的Model属性的赋值。                | ✅            | ✅         |
| 6    | **字符串的Model化**           | 字符串是json字符串，支持进行Model化解析                      | ✅            | ✅         |
| 7    | **枚举的解析**                | 当枚举解析失败时，支持兼容。                                 | ✅            | ✅         |
| 8    | **属性的自定义解析** - 重命名 | 自定义解码key（对解码的Model属性重命名）                     | ✅            | ✅         |
| 9    | **属性的自定义解析** - 忽略   | 忽略某个Model属性的解码                                      | ✅            | ✅         |
| 10   | **支持designatedPath**        | 实现自定义解析路径                                           | ✅            | ✅         |
| 11   | **Model的继承**               | 在model的继承关系下，Codable的支持力度较弱，使用不便（可以支持） | ❌            | ✅         |
| 12   | **自定义解析路径**            | 指定从json的层级开始解析                                     | ✅            | ✅         |
| 13   | **超复杂的数据解码**          | 解码过程中，多数据做进一步的整合/处理。如： 数据的扁平化处理 | ✅            | ⚠️         |
| 14   | **解码性能**                  | 在解码性能上，SmartCodable 平均强 30%                        | ✅            | ⚠️         |
| 15   | **异常解码日志**              | 当解码异常进行了兼容处理时，提供排查日志                     | ✅            | ❌         |
| 16   | **安全性方面**                | 底层实现的稳定性和安全性。                                   | ✅            | ❌         |



## FAQ

If you're looking forward to learning more about the Codable protocol and the design thinking behind SmartCodable, check it out.

如果你期望了解更多Codable协议以及SmartCodable的设计思考，请关注它。	

[👉 learn more](https://github.com/intsig171/SmartCodable/blob/develop/Document/README/LearnMore.md)



## Github Stars
![GitHub stars](https://starchart.cc/intsig171/SmartCodable.svg?theme=dark)

## Supporters
[![Stargazers repo roster for @intsig171/SmartCodable](https://reporoster.com/stars/intsig171/SmartCodable)](https://github.com/intsig171/SmartCodable/stargazers)

[![Forkers repo roster for @intsig171/SmartCodable](https://reporoster.com/forks/intsig171/SmartCodable)](https://github.com/intsig171/SmartCodable/network/members)

## Join us

**SmartCodable** is an open source project, and we welcome all developers interested in improving data parsing performance and robustness. Whether it's using feedback, feature suggestions, or code contributions, your participation will greatly advance the **SmartCodable** project.

**SmartCodable** 是一个开源项目，我们欢迎所有对提高数据解析性能和健壮性感兴趣的开发者加入。无论是使用反馈、功能建议还是代码贡献，你的参与都将极大地推动 **SmartCodable** 项目的发展。

![QQ](https://github.com/intsig171/SmartCodable/assets/87351449/5d3a98fe-17ba-402f-aefe-3e7472f35f82)
