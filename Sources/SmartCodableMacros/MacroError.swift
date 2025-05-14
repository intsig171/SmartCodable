//
//  MacroError.swift
//  SmartCodable
//
//  Created by qixin on 2025/5/14.
//

import Foundation

struct MacroError: CustomStringConvertible, Error {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var description: String {
        text
    }
}


extension MacroError {
    static func requiresExplicitType(for name: String, inferredFrom reason: String) -> MacroError {
        .init("Property '\(name)' requires an explicit type annotation; type cannot be inferred from \(reason) ")
    }
}
