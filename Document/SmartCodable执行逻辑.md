# SmartCodable



## 解析流程



### 非可选属性

#### 1. 缺少key

try impl.unwrap(as: type)

try type.init(from: self)

func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable

let decoded: T = try forceDecode(forKey: key)

使用初始化值

### 可选属性

try impl.unwrap(as: type)

try type.init(from: self)

func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable

guard let value = try? getValue(forKey: key) else { return nil }

#### 缺少key
