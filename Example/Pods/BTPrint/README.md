# BTPrint

[![CI Status](https://img.shields.io/travis/mancong@bertadata.com/BTPrint.svg?style=flat)](https://travis-ci.org/mancong@bertadata.com/BTPrint)
[![Version](https://img.shields.io/cocoapods/v/BTPrint.svg?style=flat)](https://cocoapods.org/pods/BTPrint)
[![License](https://img.shields.io/cocoapods/l/BTPrint.svg?style=flat)](https://cocoapods.org/pods/BTPrint)
[![Platform](https://img.shields.io/cocoapods/p/BTPrint.svg?style=flat)](https://cocoapods.org/pods/BTPrint)



## Installation

BTPrint is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BTPrint'

```

## Sample

```
BTLog.printBeforeLine(content: "测试输出开始")

let text = "哈哈哈123456"
BTLog.print(text)

let arr = [["我是key": ["key1":"晚上去玩"]]]
BTLog.print(arr)

let color = UIColor.red
BTLog.print(color)

let url = "https://www.baidu.com"
BTLog.print(url)

let error = NSError.init(domain: "qixin.com", code: 100, userInfo: ["a": "b"])
BTLog.print(error)

let any: Any = 123
BTLog.print(any)

BTLog.printAfterLine(content: "测试输出结束")
```

```
👇 ================测试输出开始================ 👇

【✏️ String】ViewController.swift[69]: tableView(_:didSelectRowAt:)

哈哈哈123456

【🎢 Array】ViewController.swift[73]: tableView(_:didSelectRowAt:)
(
        {
        "\U6211\U662fkey" =         {
            key1 = "\U665a\U4e0a\U53bb\U73a9";
        };
    }
)

【🎨 Color】ViewController.swift[77]: tableView(_:didSelectRowAt:)
UIExtendedSRGBColorSpace 1 0 0 1

【🌏 URL】ViewController.swift[81]: tableView(_:didSelectRowAt:)
https://www.baidu.com

【❌ Error】ViewController.swift[85]: tableView(_:didSelectRowAt:)
Error Domain=qixin.com Code=100 "(null)" UserInfo={a=b}


【🎲 Any】ViewController.swift[89]: tableView(_:didSelectRowAt:)
123

☝️ ================测试输出结束================ ☝️

```





## Author

mancong@bertadata.com

## License

BTPrint is available under the MIT license. See the LICENSE file for more info.
