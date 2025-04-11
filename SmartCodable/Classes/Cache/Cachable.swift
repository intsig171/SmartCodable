//
//  Cachable.swift
//  SmartCodable
//
//  Created by Mccc on 2024/6/3.
//

import Foundation

/// A protocol defining caching capabilities for model snapshots
/// Used to maintain state during encoding/decoding operations
protocol Cachable {
            
    associatedtype SomeSnapshot: Snapshot

    /// Array of snapshots representing the current parsing stack
    /// - Note: Using an array prevents confusion with multi-level nested models
    var snapshots: [SomeSnapshot] { set get }
    
    /// The most recent snapshot in the stack (top of stack)
    var topSnapshot: SomeSnapshot? { get }
    
    /// Caches a new snapshot for the given type
    /// - Parameter type: The model type being processed
    func cacheSnapshot<T>(for type: T.Type)
    
    /// Removes the snapshot for the given type
    /// - Parameter type: The model type to remove from cache
    mutating func removeSnapshot<T>(for type: T.Type)
}


extension Cachable {
    var topSnapshot: SomeSnapshot? {
        return snapshots.last
    }
}


/// Represents a snapshot of model state during encoding/decoding
protocol Snapshot {
    
    associatedtype ObjectType
    
    /// The current type being encoded/decoded
    var objectType: ObjectType? { set get }

    /// String representation of the object type
    var objectTypeName: String? { get }
    
    /// Records the custom transformer for properties
    var transformers: [SmartValueTransformer]? { set get }
}

extension Snapshot {
    var objectTypeName: String? {
        if let t = objectType {
            return String(describing: t)
        }
        return nil
    }
}
