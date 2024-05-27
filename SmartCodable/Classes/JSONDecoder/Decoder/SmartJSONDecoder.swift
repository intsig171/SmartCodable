// 
//  SmartJSONDecoder.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/4.
//

import Foundation

open class SmartJSONDecoder: JSONDecoder {
    
    /// Options set on the top-level encoder to pass down the decoding hierarchy.
    struct _Options {
        let dateDecodingStrategy: DateDecodingStrategy
        let dataDecodingStrategy: DataDecodingStrategy
        let nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy
        let keyDecodingStrategy: SmartKeyDecodingStrategy
        let userInfo: [CodingUserInfoKey : Any]
    }
    
    /// The options set on the top-level decoder.
    var options: _Options {
        return _Options(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: smartKeyDecodingStrategy,
            userInfo: userInfo
        )
    }
    
    open var smartKeyDecodingStrategy: SmartKeyDecodingStrategy = .useDefaultKeys

    
    // MARK: - Decoding Values

    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    open override func decode<T : Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            var parser = JSONParser(bytes: Array(data))
            let json = try parser.parse()
            let impl = JSONDecoderImpl(userInfo: self.userInfo, from: json, codingPath: [], options: self.options)
            let value = try impl.unwrap(as: type)
            SmartLog.printCacheLogs(in: "\(type)")
            return value
        } catch let error as JSONError {
            
            let err = DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: error))
            
            print(err)
            
            throw err
        } catch {
            print(error)
            throw error
        }
        
//        let topLevel: Any
//        do {
//            topLevel = try JSONSerialization.jsonObject(with: data)
//        } catch {
//            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: error))
//        }
//        
//        let decoder = _SmartJSONDecoder(referencing: topLevel, options: self.options)
//        guard let value = try decoder.unbox(topLevel, as: T.self) else {
//            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data did not contain a top-level value."))
//        }
//        SmartLog.printCacheLogs(in: "\(type)")
//        return value
    }
}


