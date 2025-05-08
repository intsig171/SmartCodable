//
//  URLTransformer.swift
//  SmartCodable
//
//  Created by Mccc on 2024/4/9.
//

import Foundation
public struct SmartURLTransformer: ValueTransformable {

    public typealias JSON = String
    public typealias Object = URL
    private let shouldEncodeURLString: Bool
    private let prefix: String?

    /**
     Initializes a URLTransformer with an option to encode the URL string before converting it to NSURL
     - parameter shouldEncodeUrlString: When true (the default value), the string is encoded before being passed
     - returns: an initialized transformer
    */
    public init(prefix: String? = nil, shouldEncodeURLString: Bool = true) {
        self.shouldEncodeURLString = shouldEncodeURLString
        self.prefix = prefix
    }
    
    
    public func transformFromJSON(_ value: Any) -> URL? {
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

    public func transformToJSON(_ value: URL) -> String? {
        return value.absoluteString
    }
}
