//
//  URLTransformer.swift
//  SmartCodable
//
//  Created by qixin on 2024/4/9.
//

import Foundation
public struct SmartURLTransformer: ValueTransformable {

    public typealias JSON = String
    public typealias Object = URL
    private let shouldEncodeURLString: Bool
    private let prefix: String?

    /**
     用一个选项初始化URLTransformer，在将URL字符串转换为NSURL之前对其进行编码
     - parameter shouldEncodeUrlString: 当为true(默认值)时，字符串在传递之前被编码
     - returns: an initialized transformer
    */
    public init(prefix: String? = nil, shouldEncodeURLString: Bool = true) {
        self.shouldEncodeURLString = shouldEncodeURLString
        self.prefix = prefix
    }
    
    
    public func transformFromJSON(_ value: Any?) -> URL? {
        guard var URLString = value as? String else { return nil }
        if let prefix = prefix, !URLString.hasPrefix(prefix) {
            URLString = prefix + URLString
        }

        
        
        if !shouldEncodeURLString {
            return URL(string: URLString)
        }

        guard let escapedURLString = URLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return nil
        }
        return URL(string: escapedURLString)
    }

    public func transformToJSON(_ value: URL?) -> String? {
        if let URL = value {
            return URL.absoluteString
        }
        return nil
    }
}
