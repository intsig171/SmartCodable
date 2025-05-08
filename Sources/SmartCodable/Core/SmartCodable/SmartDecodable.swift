//
//  SmartDecodable.swift
//  SmartCodable
//
//  Created by Mccc on 2023/9/4.
//

import Foundation

/**
 A protocol that enhances Swift's Decodable with additional customization options for decoding.
 
 Conforming types gain:
 - Post-decoding mapping callbacks
 - Custom key and value transformation strategies
 - Convenient deserialization methods
 
 Requirements:
 - Implement `didFinishMapping()` for post-processing
 - Optionally provide key/value mapping strategies
 */
public protocol SmartDecodable: Decodable {
    /// Callback invoked after successful decoding for post-processing
    mutating func didFinishMapping()
    
    /// Defines key mapping transformations during decoding
    /// First non-null mapping is preferred
    static func mappingForKey() -> [SmartKeyTransformer]?
    
    /// Defines value transformation strategies during decoding
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
    
    
    /// The default policy for date is ReferenceDate (January 1, 2001 00:00:00 UTC), in seconds.
    case date(JSONDecoder.DateDecodingStrategy)
    
    case data(JSONDecoder.SmartDataDecodingStrategy)
    
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
            logNilValue(for: "Dictionary", on: Self.self)
            return nil
        }
        
        guard let _data = getInnerData(inside: _dict, by: designatedPath) else {
            logDataExtractionFailure(forPath: designatedPath, type: Self.self)
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
            logNilValue(for: "JSON String", on: Self.self)
            return nil
        }
        
        guard let _data = getInnerData(inside: _json, by: designatedPath) else {
            logDataExtractionFailure(forPath: designatedPath, type: Self.self)
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
            logNilValue(for: "Data", on: Self.self)
            return nil
        }
        
        guard let _data = getInnerData(inside: data, by: designatedPath) else {
            logDataExtractionFailure(forPath: designatedPath, type: Self.self)
            return nil
        }
        
        return _data._deserializeDict(type: Self.self, options: options)
    }
    
    
    /// Deserializes into a model
    /// - Parameter data: Data
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Model
    public static func deserializePlist(from data: Data?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self? {
        
        guard let data = data else {
            logNilValue(for: "Data", on: Self.self)
            return nil
        }
        
        guard let _tranData = data.tranformToJSONData(type: Self.self) else {
            return nil
        }
        
        guard let _data = getInnerData(inside: _tranData, by: designatedPath) else {
            logDataExtractionFailure(forPath: designatedPath, type: Self.self)
            return nil
        }
        
        return _data._deserializeDict(type: Self.self, options: options)
    }

}


extension Array where Element: SmartDecodable {
    
    /// Deserializes into an array of models
    /// - Parameter array: Array
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Array of models
    public static func deserialize(from array: [Any]?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        
        guard let _arr = array else {
            logNilValue(for: "Array", on: Self.self)
            return nil
        }
        
        guard let _data = getInnerData(inside: _arr, by: nil) else {
            logDataExtractionFailure(forPath: designatedPath, type: Self.self)
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
            logNilValue(for: "JSON String", on: Self.self)
            return nil
        }
        
        guard let _data = getInnerData(inside: _json, by: designatedPath) else {
            logDataExtractionFailure(forPath: designatedPath, type: Self.self)
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
            logNilValue(for: "Data", on: Self.self)
            return nil
        }
        
        guard let _data = getInnerData(inside: data, by: designatedPath) else {
            logDataExtractionFailure(forPath: designatedPath, type: Self.self)
            return nil
        }
        
        return _data._deserializeArray(type: Self.self, options: options)
    }
    
    /// Deserializes into an array of models
    /// - Parameter data: Data
    /// - Parameter designatedPath: Specifies the data path to decode
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Array of models
    public static func deserializePlist(from data: Data?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        
        
        guard let data = data else {
            logNilValue(for: "Data", on: Self.self)
            return nil
        }
        
        guard let _tranData = data.tranformToJSONData(type: Self.self) else {
            return nil
        }
        
        guard let _data = getInnerData(inside: _tranData, by: designatedPath) else {
            logDataExtractionFailure(forPath: designatedPath, type: Self.self)
            return nil
        }
        
        return _data._deserializeArray(type: Self.self, options: options)
    }
}


extension Data {
    fileprivate func createDecoder<T>(type: T.Type, options: Set<SmartDecodingOption>? = nil) -> JSONDecoder {
        let _decoder = SmartJSONDecoder()
        
        if let _options = options {
            for _option in _options {
                switch _option {
                case .data(let strategy):
                    _decoder.smartDataDecodingStrategy = strategy
                    
                case .date(let strategy):
                    _decoder.smartDateDecodingStrategy = strategy
                    
                case .float(let strategy):
                    _decoder.nonConformingFloatDecodingStrategy = strategy
                case .key(let strategy):
                    _decoder.smartKeyDecodingStrategy = strategy
                }
            }
        }
        
        return _decoder
    }
    
    
    fileprivate func _deserializeDict<T>(type: T.Type, options: Set<SmartDecodingOption>? = nil) -> T? where T: SmartDecodable {

        do {
            let _decoder = createDecoder(type: type, options: options)
            var obj = try _decoder.decode(type, from: self)
            obj.didFinishMapping()
            return obj
        } catch {
            return nil
        }
    }
    
    
    fileprivate func _deserializeArray<T>(type: [T].Type, options: Set<SmartDecodingOption>? = nil) -> [T]? where T: SmartDecodable {

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
    
    
    /// 将Plist Data 转成 JSON Data
    fileprivate func tranformToJSONData(type: Any.Type) -> Data? {
        guard let jsonObject = try? PropertyListSerialization.propertyList(from: self, options: [], format: nil) else {
            SmartSentinel.monitorAndPrint(debugDescription: "Failed to convert PropertyList Data to JSON Data.", in: type)
            return nil
        }
        
        guard JSONSerialization.isValidJSONObject(jsonObject) else {
            SmartSentinel.monitorAndPrint(debugDescription: "Failed to convert PropertyList Data to JSON Data.", in: type)
            return nil
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return jsonData
        } catch {
            SmartSentinel.monitorAndPrint(debugDescription: "Failed to convert PropertyList Data to JSON Data. ", error: error, in: type)
            return nil
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    
    /// 确保字典中的Value类型都支持JSON序列化。
    func toData() -> Data? {
        let jsonCompatibleDict = self.toJSONCompatibleDict()
        guard JSONSerialization.isValidJSONObject(jsonCompatibleDict) else { return nil }
        return try? JSONSerialization.data(withJSONObject: jsonCompatibleDict)
    }

    private func toJSONCompatibleDict() -> [String: Any] {
        var jsonCompatibleDict: [String: Any] = [:]
        for (key, value) in self {
            jsonCompatibleDict[key] = convertToJSONCompatible(value: value)
        }
        return jsonCompatibleDict
    }
    
    /// 目前只处理了Data类型。如有需要可以继续扩展补充。
    private func convertToJSONCompatible(value: Any) -> Any {
        if let data = value as? Data {
            return data.base64EncodedString()
        } else if let dict = value as? [String: Any] {
            return dict.toJSONCompatibleDict()
        } else if let array = value as? [Any] {
            return array.map { convertToJSONCompatible(value: $0) }
        } else {
            return value
        }
    }
    
    fileprivate func toJSONString() -> String? {
        guard let data = toData() else { return nil }
        return String(data: data, encoding: .utf8)
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


fileprivate func logNilValue(for valueType: String, on modelType: Any.Type) {
    SmartSentinel.monitorAndPrint(debugDescription: "Decoding \(modelType) failed because input \(valueType) is nil.", in: modelType)
}

fileprivate func logDataExtractionFailure(forPath path: String?, type: Any.Type) {
    
    SmartSentinel.monitorAndPrint(debugDescription: "Decoding \(type) failed because it was unable to extract valid data from path '\(path ?? "nil")'.", in: type)
}
