# #suggest 5 提供全局的Key映射策略



## 新提供了SmartKeyDecodingStrategy枚举

```
public enum SmartKeyDecodingStrategy : Sendable {
    /// 默认的解析策略
    case useDefaultKeys

    /// 蛇形命名转驼峰命名
    case fromSnakeCase
    
    /// 首字母大写转小写
    case firstLetterLower
}
```

如有其他需要的策略可以提issue。



在解析之前，根据SmartKeyDecodingStrategy先对数据做处理。遍历字典，把字典的key进行处理。

```
    init(referencing decoder: _SmartJSONDecoder, wrapping container: [String : Any]) {
        self.decoder = decoder
        self.codingPath = decoder.codingPath
        
        switch decoder.options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.container = container
        case .fromSnakeCase:
            self.container = Dictionary(container.map {
                dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
        case .firstLetterLower:
            self.container = Dictionary(container.map {
                dict in (JSONDecoder.SmartKeyDecodingStrategy._convertFirstLetterToLowercase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
        }
    }
```



正如描述枚举项对描述所说：

> 应该谨慎使用此策略，它会产生一定的性能成本，因为每个键的每个字符都需要检查并可能进行修改。
