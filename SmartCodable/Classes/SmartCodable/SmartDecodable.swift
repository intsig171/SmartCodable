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
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Model
    public static func deserialize(from dict: [String: Any]?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self? {
        guard let _dict = dict else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return nil
        }

        guard let _json = _dict.toJSONString() else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be json.", in: "\(self)")
            return nil
        }
        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be data.", in: "\(self)")
            return nil
        }

        return deserialize(from: _jsonData, designatedPath: designatedPath, options: options)
    }

    /// Deserializes into a model
    /// - Parameter json: JSON string
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Model
    public static func deserialize(from json: String?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self? {
        guard let _json = json else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return nil
        }

        guard let jsonData = _json.data(using: .utf8) else {
            SmartLog.logVerbose("Expected to decode Dictionary but is cannot be data.", in: "\(self)")
            return nil
        }

        return deserialize(from: jsonData, designatedPath: designatedPath, options: options)
    }


    /// Deserializes into a model
    /// - Parameter data: Data
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Model
    public static func deserialize(from data: Data?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> Self? {
        guard let _data = data else {
            SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
            return nil
        }

        do {
            if let path = designatedPath, let nestedObject = _data.getInnerObject(byPath: path) {
                let jsonData = try JSONSerialization.data(withJSONObject: nestedObject)
                return try jsonData._deserializeDict(type: Self.self, options: options)
            } else {
                return try _data._deserializeDict(type: Self.self, options: options)
            }
       } catch {
           SmartLog.logVerbose("Expected to decode Dictionary but found nil instead.", in: "\(self)")
           return nil
       }
    }
}




extension Array where Element: SmartDecodable {

    /// Deserializes into an array of models
    /// - Parameter array: Array
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Array of models
    public static func deserialize(from array: [Any]?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> [Element]? {

        guard let _arr = array else {
            SmartLog.logVerbose("Expected to decode Array but found nil instead.", in: "\(self)")
            return nil
        }

        guard let _json = _arr.toJSONString() else {
            SmartLog.logVerbose("Expected to decode Array but is cannot be json.", in: "\(self)")
            return nil
        }

        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logVerbose("Expected to decode Array but is cannot be data.", in: "\(self)")
            return nil
        }
        return deserialize(from: _jsonData, designatedPath: designatedPath, options: options)
    }


    /// Deserializes into an array of models
    /// - Parameter json: JSON string
    /// - Parameter options: Decoding strategy
    ///   Only one enumeration item is allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Array of models
    public static func deserialize(from json: String?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        guard let _json = json else {
            SmartLog.logVerbose("Expected to decode Array but found nil instead.", in: "\(self)")
            return nil
        }


        guard let _jsonData = _json.data(using: .utf8) else {
            SmartLog.logVerbose("Expected to decode Array but is cannot be data.", in: "\(self)")
            return nil
        }

        return deserialize(from: _jsonData, designatedPath: designatedPath, options: options)
    }

    /// Deserializes into an array of models
    /// - Parameter data: Data
    /// - Parameter options: Decoding strategy
    ///   Duplicate enumeration items are not allowed, e.g., multiple keyStrategies cannot be passed in [only the first one is effective].
    /// - Returns: Array of models
    public static func deserialize(from data: Data?, designatedPath: String? = nil, options: Set<SmartDecodingOption>? = nil) -> [Element]? {
        guard let _data = data else {
            SmartLog.logVerbose("Expected to decode Array but found nil instead.", in: "\(self)")
            return nil
        }

        do {
            if let path = designatedPath, !path.isEmpty {
                if let nestedObject = _data.getInnerObject(byPath: path) {
                    let jsonData = try JSONSerialization.data(withJSONObject: nestedObject)
                    return try jsonData._deserializeArray(type: Self.self, options: options)
                } else {
                    SmartLog.logVerbose("No nested object found at the designated path", in: "\(self)")
                    return nil
                }
            } else {
                return try _data._deserializeArray(type: Self.self, options: options)
            }
        } catch {
            SmartLog.logVerbose("Expected to decode Array but found nil instead.", in: "\(self)")
            return nil
        }
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

    fileprivate func getInnerObject(byPath path: String) -> Any? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
            if let dictionary = jsonObject as? [String: Any] {
                var currentObject: Any? = dictionary
                for key in path.components(separatedBy: ".") {
                    if let dict = currentObject as? [String: Any] {
                        currentObject = dict[key]
                    } else {
                        SmartLog.logVerbose("Invalid path or path does not lead to a dictionary", in: "\(self)")
                        return nil
                    }
                }
                return currentObject
            } else {
                SmartLog.logVerbose("JSON is not a dictionary", in: "\(self)")
                return nil
            }
        } catch {
            SmartLog.logVerbose("Invalid path or path does not lead to a dictionary", in: "\(self)")
            return nil
        }
    }
}

extension Dictionary where Key == String {
    fileprivate func toJSONString() -> String? {

        let peeledDict = self.peelIfPresent
        guard JSONSerialization.isValidJSONObject(peeledDict) else { return nil }

        if let data = try? JSONSerialization.data(withJSONObject: peeledDict) {
            if let json = String(data: data, encoding: String.Encoding.utf8) {
                return json
            }
        }
        return nil
    }
}

extension String {
    fileprivate func toDictionary() -> Dictionary<String, Any>? {
        guard let jsonData:Data = data(using: .utf8) else { return nil }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            if let temp = dict as? Dictionary<String, Any> {
                return temp
            }
        }
        return nil
    }

    fileprivate func toArray() -> Array<Any>? {
        guard let jsonData:Data = data(using: .utf8) else { return nil }
        if let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            if let temp = array as? Array<Any> {
                return temp
            }
        }
        return nil
    }
}
extension Array {
    fileprivate func toJSONString() -> String? {
        let peeledArr = self.peelIfPresent
        guard JSONSerialization.isValidJSONObject(peeledArr) else { return nil }
        do {
            let data = try JSONSerialization.data(withJSONObject: peeledArr, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return json
        } catch {
            return nil
        }
    }
}

