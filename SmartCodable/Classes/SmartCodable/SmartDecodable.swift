//
//  SmartDecodable.swift
//  SmartCodable
//
//  Created by qixin on 2023/9/4.
//

import Foundation


public protocol SmartDecodable: Decodable {
    /// The callback for when mapping is complete
    mutating func didFinishMapping()
  
    /// The mapping relationship of decoding keys
    static func mappingForKey() -> [SmartKeyTransformer]?
    
    /// The strategy for decoding values
    static func mappingForValue() -> [SmartValueTransformer]?
    
    init()
}


extension SmartDecodable {
    public mutating func didFinishMapping() { }
    public static func mappingForKey() -> [SmartKeyTransformer]? { return nil }
    public static func mappingForValue() -> [SmartValueTransformer]? { return nil }
}


/// Options for SmartCodable parsing
public enum SmartDecodingOption: Hashable {
    
    
    /// date的默认策略是ReferenceDate（参考日期是指2001年1月1日 00:00:00 UTC），以秒为单位。
    case date(JSONDecoder.DateDecodingStrategy)
    
    case data(JSONDecoder.DataDecodingStrategy)
    
    case float(JSONDecoder.NonConformingFloatDecodingStrategy)
    
    /// The mapping strategy for keys during parsing
    case key(JSONDecoder.SmartKeyDecodingStrategy)
    
    /// Handles the hash value, ignoring the impact of associated values.
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .date:
            hasher.combine(0)
        case .data:
            hasher.combine(1)
        case .float:
            hasher.combine(2)
        case .key:
            hasher.combine(3)
        }
    }
    
    public static func == (lhs: SmartDecodingOption, rhs: SmartDecodingOption) -> Bool {
        switch (lhs, rhs) {
        case (.date, .date):
            return true
        case (.data, .data):
            return true
        case (.float, .float):
            return true
        case (.key, .key):
            return true
        default:
            return false
        }
    }
}


extension SmartDecodable {
    
    /// Deserializes into a model
    /// - Parameter dict: Dictionary
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Model
    public static func deserialize(from dict: [String: Any]?, designatedPath: String? = nil,  options: Set<SmartDecodingOption>? = nil) -> Self? {
                
        guard let _dict = dict else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return nil
        }
        
        guard let _data = getInnerData(inside: _dict, by: designatedPath) else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be data.", in: "\(self)")
            return nil
        }
        
        return deserialize(from: _data, options: options)
    }
    
    /// Deserializes into a model
    /// - Parameter json: JSON string
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Model
    public static func deserialize(from json: String?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self? {
        guard let _json = json else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return nil
        }
    
        guard let _data = getInnerData(inside: _json, by: designatedPath) else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be data.", in: "\(self)")
            return nil
        }
        
        return deserialize(from: _data, options: options)
    }
    
    
    /// Deserializes into a model
    /// - Parameter data: Data
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Model
    public static func deserialize(from data: Data?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self? {
        guard let data = data else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return nil
        }
        
        guard let _data = getInnerData(inside: data, by: designatedPath) else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be data.", in: "\(self)")
            return nil
        }
        
        return try? _data._deserializeDict(type: Self.self, options: options)
    }
}



extension Array where Element: SmartDecodable {
    
    /// Deserializes into an array of models
    /// - Parameter array: Array
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Array of models
    public static func deserialize(from array: [Any]?, options: Set<SmartDecodingOption>? = nil) -> [Element]? {

        guard let _arr = array else {
            SmartLog.logVerbose("Expected to decode Array but found nil instead.", in: "\(self)")
            return nil
        }
        
        guard let _data = getInnerData(inside: _arr, by: nil) else {
            SmartLog.logVerbose("Expected to decode Array but is cannot be data.", in: "\(self)")
            return nil
        }
        
        return deserialize(from: _data, options: options)
    }
    
    
    /// Deserializes into an array of models
    /// - Parameter json: JSON string
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Only one enumeration item is allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Array of models
    public static func deserialize(from json: String?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        guard let _json = json else {
            SmartLog.logVerbose("Expected to decode Array but found nil instead.", in: "\(self)")
            return nil
        }
        
        guard let _data = getInnerData(inside: _json, by: designatedPath) else {
            SmartLog.logVerbose("Expected to decode Array but is cannot be data.", in: "\(self)")
            return nil
        }
        
        return deserialize(from: _data, options: options)
    }
    
    /// Deserializes into an array of models
    /// - Parameter data: Data
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Array of models
    public static func deserialize(from data: Data?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        guard let data = data else {
            SmartLog.logVerbose("Expected to decode Array but found nil instead.", in: "\(self)")
            return nil
        }
        
        guard let _data = getInnerData(inside: data, by: designatedPath) else {
            SmartLog.logVerbose("Expected to decode Array but is cannot be data.", in: "\(self)")
            return nil
        }
        
        return try? _data._deserializeArray(type: Self.self, options: options)
    }
}


extension Data {

    fileprivate func createDecoder<T>(type: T.Type, options: Set<SmartDecodingOption>? = nil) -> JSONDecoder {
        let _decoder = SmartJSONDecoder()
        

        if let _options = options {
            for _option in _options {
                switch _option {
                case .data(let strategy):
                    _decoder.dataDecodingStrategy = strategy
                    
                case .date(let strategy):
                    _decoder.dateDecodingStrategy = strategy
                    
                case .float(let strategy):
                    _decoder.nonConformingFloatDecodingStrategy = strategy
                case .key(let strategy):
                    _decoder.smartKeyDecodingStrategy = strategy
                }
            }
        }
        
        return _decoder
    }
    
    
    fileprivate func _deserializeDict<T>(type: T.Type, options: Set<SmartDecodingOption>? = nil) throws -> T? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, options: options)
            var obj = try _decoder.decode(type, from: self)
            obj.didFinishMapping()
            return obj
        } catch {
            return nil
        }
    }
    
    
    fileprivate func _deserializeArray<T>(type: [T].Type, options: Set<SmartDecodingOption>? = nil) throws -> [T]? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, options: options)
            let decodeValue = try _decoder.decode(type, from: self)
            return decodeValue
        } catch {
            return nil
        }
    }
    
    fileprivate func toObject() -> Any? {
        let jsonObject = try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return jsonObject
    }
}

extension Dictionary where Key == String {
    
    fileprivate func toData() -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        return try? JSONSerialization.data(withJSONObject: self)
    }
    
    fileprivate func toJSONString() -> String? {
        guard let data = toData() else { return nil }
        if let json = String(data: data, encoding: String.Encoding.utf8) {
            return json
        }
        return nil
    }
}

extension Array {
    
    fileprivate func toData() -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        return try? JSONSerialization.data(withJSONObject: self)
    }
    
    fileprivate func toJSONString() -> String? {
        guard let data = toData() else { return nil }
        if let json = String(data: data, encoding: String.Encoding.utf8) {
            return json
        }
        return nil
    }
}

/// 通过路径获取待解析的信息，再转换成data，提供给decoder解析。
fileprivate func getInnerData(inside value: Any?, by designatedPath: String?) -> Data? {
    
    func toObject(_ value: Any?) -> Any? {
        
        switch value {
        case let data as Data:
            return data.toObject() // 确保这里 toObject() 方法是有效且能正确处理 Data 的。
        case let json as String:
            return Data(json.utf8).toObject() // 直接使用 Data 初始化器。
        case let dict as [String: Any]:
            return dict
        case let arr as [Any]:
            return arr
        default:
            return nil
        }
    }

    func toData(_ value: Any?) -> Data? {
        switch value {
        case let data as Data:
            return data
        case let str as String:
            return Data(str.utf8)
        case let dict as [String: Any]:
            return dict.toData()
        case let arr as [Any]:
            return arr.toData()
        default:
            break
        }
        return nil
    }

    func getInnerObject(inside object: Any?, by designatedPath: String?) -> Any? {
        
        var result: Any? = object
        var abort = false
        if let paths = designatedPath?.components(separatedBy: "."), paths.count > 0 {
            var next = object as? [String: Any]
            paths.forEach({ (seg) in
                if seg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || abort {
                    return
                }
                if let _next = next?[seg] {
                    result = _next
                    next = _next as? [String: Any]
                } else {
                    abort = true
                }
            })
        }
        return abort ? nil : result
    }
    
    
    if let path = designatedPath, !path.isEmpty {
        let obj = toObject(value)
        let inner = getInnerObject(inside: obj, by: path)
        return toData(inner)
    } else {
        return toData(value)
    }
}

