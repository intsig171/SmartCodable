//
//  ModelMemberPropertyContainer.swift
//  SmartCodable
//
//  Created by qixin on 2025/5/14.
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Represents information about a property in a class
struct ModelMemberProperty {
    let name: String
    let type: String
    let isWrapped: Bool
    let isStored: Bool
      
    var codingKeyName: String {
        return name
    }
    
    var accessName: String {
        isWrapped ? "_\(name)" : name
    }
}
