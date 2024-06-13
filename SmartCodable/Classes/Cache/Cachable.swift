//
//  Cachable.swift
//  SmartCodable
//
//  Created by qixin on 2024/6/3.
//

import Foundation


protocol Cachable {
    
    associatedtype CacheType
    
    var cacheType: CacheType? { get set }
    
    /// Stores a snapshot of the Model being parsed.
    /// Why array records must be used
    /// - avoid parsing confusion with multi-level nested models
    var snapshots: [Snapshot] { set get }
    
    var topSnapshot: Snapshot? { get }
    
    func cacheSnapshot<T>(for type: T.Type)
    
    mutating func removeSnapshot<T>(for type: T.Type)
}


extension Cachable {
    var topSnapshot: Snapshot? {
        return snapshots.last
    }
    
    mutating func removeSnapshot<T>(for type: T.Type) {
        
        // If the current type being decoded does not inherit from SmartDecodable Model, it does not need to be processed.
        // The properties within the model being decoded should not be cleared. They can be cleared only after decoding is complete.
        if let _ = T.self as? CacheType {
            if snapshots.count > 0 {
                snapshots.removeLast()
            }
        }
    }
}


struct Snapshot {
    /// The current decoding type
    var typeName: String = ""
    
    /// The current decoding path (ensuring the correspondence through the decoding path)
    var initialValues: [String: Any] = [:]
    
    /// Records the custom transformer for properties
    var transformers: [SmartValueTransformer] = []
}
