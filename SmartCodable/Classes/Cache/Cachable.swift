//
//  Cachable.swift
//  SmartCodable
//
//  Created by Mccc on 2024/6/3.
//

import Foundation


protocol Cachable {
            
    associatedtype SomeSnapshot: Snapshot

    /// Stores a snapshot of the Model being parsed.
    /// Why array records must be used
    /// - avoid parsing confusion with multi-level nested models
    var snapshots: [SomeSnapshot] { set get }
    
    var topSnapshot: SomeSnapshot? { get }
    
    func cacheSnapshot<T>(for type: T.Type)
    
    mutating func removeSnapshot<T>(for type: T.Type)
}


extension Cachable {
    var topSnapshot: SomeSnapshot? {
        return snapshots.last
    }
}


protocol Snapshot {
    
    associatedtype ObjectType

    
    /// The current decoding or encoding type
    var objectType: ObjectType? { set get }

    var objectTypeName: String? { get }
    
    /// The current decoding path (ensuring the correspondence through the decoding path)
    var initialValues: [String: Any] { set get }
    
    /// Records the custom transformer for properties
    var transformers: [SmartValueTransformer] { set get }
}

extension Snapshot {
    var objectTypeName: String? {
        if let t = objectType {
            return String(describing: t)
        }
        return nil
    }
}
