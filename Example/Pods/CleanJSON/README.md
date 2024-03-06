# CleanJSON

[![build](https://github.com/Pircate/CleanJSON/workflows/build/badge.svg)](https://github.com/Pircate/CleanJSON/actions?query=workflow%3ASwift)
[![Version](https://img.shields.io/cocoapods/v/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM support](https://camo.githubusercontent.com/db4e680db88f755692b027d972041b38481bb65f92659e5484c41373d82b94a0/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f53504d2d737570706f727465642d4445354334332e7376673f7374796c653d666c6174)](https://swift.org/package-manager/)
[![License](https://img.shields.io/cocoapods/l/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)
[![Platform](https://img.shields.io/cocoapods/p/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)
[![codebeat badge](https://codebeat.co/badges/4306b03d-6f8d-46c5-b30e-70ca9015d57f)](https://codebeat.co/projects/github-com-pircate-cleanjson-master)


继承自 JSONDecoder，在标准库源码基础上做了改动，以解决 JSONDecoder 各种解析失败的问题，如键值不存在，值为 null，类型不一致。

> 只需将 JSONDecoder 替换成 CleanJSONDecoder。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 9.0
* Swift 5.2

## Installation

CleanJSON is available through [CocoaPods](https://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Podfile or Cartfile:

#### Podfile

```ruby
pod 'CleanJSON'
```

#### Cartfile

```ruby
github "Pircate/CleanJSON"
```

## Import

```swift
import CleanJSON
```

## Usage

### Normal

```swift
let decoder = CleanJSONDecoder()
try decoder.decode(Model.self, from: data)

// 支持直接解析符合 JSON 规范的字典和数组
try decoder.decode(Model.self, from: ["key": value])
```

### Enum

对于枚举类型请遵循 `CaseDefaultable` 协议，如果解析失败会返回默认 case

**Note: 枚举使用强类型解析，关联类型和数据类型不一致不会进行类型转换，会解析为默认 case**

```swift
enum Enum: Int, Codable, CaseDefaultable {
    
    case case1
    case case2
    case case3
    
    static var defaultCase: Enum {
        return .case1
    }
}
```

### Customize decoding strategy

可以通过 `valueNotFoundDecodingStrategy` 在值为 null 或类型不匹配的时候自定义解码，默认策略请看[这里](https://github.com/Pircate/CleanJSON/blob/master/CleanJSON/Classes/JSONAdapter.swift)

```swift
struct CustomAdapter: JSONAdapter {
    
    // 由于 Swift 布尔类型不是非 0 即 true，所以默认没有提供类型转换。
    // 如果想实现 Int 转 Bool 可以自定义解码。
    func adapt(_ decoder: CleanDecoder) throws -> Bool {
        // 值为 null
        if decoder.decodeNil() {
            return false
        }
        
        if let intValue = try decoder.decodeIfPresent(Int.self) {
            // 类型不匹配，期望 Bool 类型，实际是 Int 类型
            return intValue != 0
        }
        
        return false
    }
    
    // 为避免精度丢失所以没有提供浮点型转整型
    // 可以通过下面适配器进行类型转换
    func adapt(_ decoder: CleanDecoder) throws -> Int {
        guard let doubleValue = try decoder.decodeIfPresent(Double.self) else { return 0 }
        
        return Int(doubleValue)
    }
    
    // 可选的 URL 类型解析失败的时候返回一个默认 url
    func adaptIfPresent(_ decoder: CleanDecoder) throws -> URL? {
        return URL(string: "https://google.com")
    }
}

decoder.valueNotFoundDecodingStrategy = .custom(CustomAdapter())
```

可以通过 `JSONStringDecodingStrategy` 将 JSON 格式的字符串自动转成 `Codable` 对象或数组

```swift
// 包含这些 key 的 JSON 字符串转成对象
decoder.jsonStringDecodingStrategy = .containsKeys([])

// 所有 JSON 字符串都转成对象
decoder.jsonStringDecodingStrategy = .all
```

为 `keyDecodingStrategy` 新增了一个自定义映射器，可以只映射指定 coding path 的 key 

```swift
decoder.keyDecodingStrategy = .mapper([
    ["snake_case"]: "snakeCase",
    ["nested", "alpha"]: "a"
])
```

### For Moya

使用 `Moya.Response` 自带的 [map](https://github.com/Moya/Moya/blob/master/Sources/Moya/Response.swift) 方法解析，传入 `CleanJSONDecoder`

```swift
provider = MoyaProvider<GitHub>()
provider.request(.zen) { result in
    switch result {
    case let .success(response):
        let decoder = CleanJSONDecoder()
        let model = response.map(Model.self, using: decoder)
    case let .failure(error):
        // this means there was a network failure - either the request
        // wasn't sent (connectivity), or no response was received (server
        // timed out).  If the server responds with a 4xx or 5xx error, that
        // will be sent as a ".success"-ful response.
    }
}
```

### For RxMoya

```swift
provider = MoyaProvider<GitHub>()

let decoder = CleanJSONDecoder()
provider.rx.request(.userProfile("ashfurrow"))
    .map(Model.self, using: decoder)
    .subscribe { event in
        switch event {
        case let .success(model):
            // do someting
        case let .error(error):
            print(error)
        }
    }
```

## Author

Pircate, swifter.dev@gmail.com

## License

CleanJSON is available under the MIT license. See the LICENSE file for more info.
