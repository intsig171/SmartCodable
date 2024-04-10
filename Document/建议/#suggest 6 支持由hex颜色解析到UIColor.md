# #suggest 6 支持由hex颜色解析到UIColor



## 为什么UIColor不能直接实现Codable

有一些场景，数据的给的是这样的 **"7DA5E3"** 颜色字符串。期望解析到UIColor类型的属性上。

```
struct Model: Codable {
    var color: UIColor?
}
```

但是报错： 

```
Type 'Model' does not conform to protocol 'Decodable'
Type 'Model' does not conform to protocol 'Encodable'
```

是因为Date没有遵循 **Codable** 协议。我们按照要求帮UIColor实现Codable

```
extension UIColor: Codable {
    public func encode(to encoder: Encoder) throws {
        // todo
    }
    
    public required convenience init(from decoder: Decoder) throws {
        // todo 
    }
}
```

代码报错： 

```
代码报错： Initializer requirement 'init(from:)' can only be satisfied by a 'required' initializer in the definition of non-final class 'UIColor'
```

因为试图在 `UIColor` 的扩展中实现 `Codable` 协议的初始化器 `init(from:)`，但 `UIColor` 是一个来自 UIKit 的非最终类（non-final class）。根据 Swift 的规则，非最终类中的指定初始化器（designated initializer）需要标记为 `required`，以确保所有的子类都能提供这个初始化器。但是，你不能在扩展中为现有的非最终类添加 `required` 初始化器。

> 如何理解 **非最终类**
>
> ```
> open class UIColor : NSObject, NSSecureCoding, NSCopying, @unchecked Sendable { }
> ```
>
> 在Swift语言中，非最终类（non-final class）是默认状态，意味着任何类都可以被其他类继承，除非显式地将其标记为 `final`。
>
> #### Swift中的非最终类特点
>
> 1. **继承性**：非最终类允许其他类继承自己，子类可以继承父类的属性和方法。
> 2. **多态性**：子类可以重写父类的方法，实现多态。这意味着同一个方法可以根据对象的实际类型表现出不同的行为。
> 3. **动态派发**：在Swift中，非最终类的方法通常是动态派发的，这意味着方法的具体实现将在运行时决定，而不是编译时。
>
> #### 为什么非最终类不能简单地实现`Codable`的`init(from:)`
>
> 1. **类型安全和多态**：Swift是一门强类型语言，它在编译时做了大量的类型检查以确保代码的安全性。`Codable`协议的`init(from:)`方法被设计为一个`required`初始化器，这意味着任何继承自该类的子类都必须实现这个初始化器。这是因为解码操作需要能够实例化任何在解码过程中遇到的具体类类型，包括所有的子类。
> 2. **继承和覆盖问题**：在非最终类中，子类可以覆盖父类的方法和初始化器。如果父类实现了`Codable`的`init(from:)`方法，子类也需要提供这个初始化器的自己的实现（除非子类也是最终的）。这引入了一个潜在的问题：子类在覆盖`init(from:)`时必须调用父类的`init(from:)`，保证所有继承来的属性都被正确初始化。这个要求在复杂的继承体系中可能导致错误或遗漏。
>
> #### 解决方案和最佳实践
>
> 为了避免这些问题，当你工作于非最终类并且想要实现`Codable`时，以下是一些解决方案和最佳实践：
>
> - **设计为最终类**：如果可能，设计你的类为`final`。这样，编译器会阻止其他类继承自这个类，你可以安全地实现`Codable`而不用担心继承和覆盖的问题。
> - **使用结构体**：Swift的结构体（`struct`）不能被继承，这使它们成为实现`Codable`的理想选择，特别是当你的数据模型比较简单，不需要复杂的继承关系时。
> - **组合而非继承**：考虑使用组合替代继承。你可以将可编码的属性移到一个或多个结构体中，然后在你的类中包含这些结构体作为属性。这样，你就可以保持类的灵活性，同时避开由于继承导致的`Codable`实现问题。



## 解决方案

跟 **SamrtAny** 的实现逻辑一样，使用 **enum** 包裹 **UIColor**。

```
public enum SmartColor {
    case color(UIColor)
    
    public init(from value: UIColor) {
        self = .color(value)
    }
    
    /// 解包
    public var peel: UIColor {
        switch self {
        case .color(let c):
            return c
        }
    }
}

extension SmartColor: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        guard let color = UIColor.hex(hexString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode UIColor from provided hex string.")
        }
        self = .color(color)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .color(let color):
            try container.encode(color.hexString)
        }
    }
}
```

