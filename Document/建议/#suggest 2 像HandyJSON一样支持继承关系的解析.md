# #suggest 2 像HandyJSON一样支持继承关系的解析



## HandyJSON 如何处理继承关系的解析的？

```
class BaseModel: HandyJSON {
    var name: String = ""
    required init() { }
}

class Model: BaseModel {
    var age: Int = 0
}

let dict = [
    "name": "小明",
    "age": 10
] as [String : Any]

guard let model = Model.deserialize(from: dict) else { return }
print(model.age)
print(model.name)
```

不得不感叹：HandyJSON在处理继承关系上确实好用。



## SmartCodable 如何处理继承关系的解析的？

父类遵循了`Codable`协议，所以系统针对父类自动生成了

* `encode(to encoder: Encoder)`方法 
*  `required init(from decoder: Decoder)` 方法。

子类虽然继承自父类，但并没有重写这两个方法，所以在编码过程中，找到的依然是父类的方法，最终仅父类属性可以被成功编码。



### 通过SIL验证

```
class BaseModel : Decodable & Encodable {
    
    @_hasStorage @_hasInitialValue var name: String { get set }
    required init()
    
    enum CodingKeys : CodingKey {
        case name
        
        func hash(into hasher: inout Hasher)
        init?(stringValue: String)
        init?(intValue: Int)
        var hashValue: Int { get }
        var intValue: Int? { get }
        var stringValue: String { get }
    }
    
    @objc deinit
    func encode(to encoder: Encoder) throws
    required init(from decoder: Decoder) throws
}
```

BaseModel的SIL代码中：

* 系统自动生成了CodingKeys
* 系统自动生成了 `func encode(to encoder: Encoder)`
* 系统自动生成了 `required init(from decoder: Decoder) throws`

```
@_inheritsConvenienceInitializers class SubModel : BaseModel {
    @_hasStorage @_hasInitialValue var age: Int { get set }
    required init()
    required init(from decoder: Decoder) throws
    @objc deinit
}
```

SubModel的SIL代码中：

系统自动生成了 `required init(from decoder: Decoder) throws`



对于基类，编译器可以自动合成`encode(to:)`和`init(from:)`方法。

对于子类，编译器只会自动合成`init(from:)`方法，因为它是一个`required`初始化器。

这是因为子类可能会添加新的属性，而编译器不知道如何自动合成这些新属性的编码逻辑，除非它们也都是`Codable`。



对于`init(from decoder:)`方法即便子类SIL中显示了`required init(from decoder: Decoder) throws`的存在，如果没有在这个方法中显式地处理`age`属性的解码逻辑，`age`就不会被自动解码。所以，正如之前解释的，要确保`age`属性被正确解码，你需要在`Model`类中实现自定义的解码逻辑

对于`encode(to:)`方法，编译器不会自动合成这个方法，因为它不是必须的（不是`required`）。如果你的子类添加了新的`Codable`属性，并且你没有提供自定义的`encode(to:)`方法，那么这些新属性将不会被编码。在这种情况下，你需要手动实现`encode(to:)`方法来确保所有属性都被正确编码。



### 正确的处理继承关系的解码

```
class BaseModel: SmartCodable {
    var name: String = ""
    required init() { }
}

class Model: BaseModel {
    var age: Int = 0
    
    private enum CodingKeys: CodingKey {
        case age
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.age = try container.decode(Int.self, forKey: .age)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(age, forKey: .age)
        try super.encode(to: encoder)
    }
    
    required init() {
        super.init()
    }
}
```



在子类中重写`init(from decoder:)`方法，完成子类属性解码的同时，执行`try super.init(from: decoder)`方法调用父类的`init(from decoder:)`。 