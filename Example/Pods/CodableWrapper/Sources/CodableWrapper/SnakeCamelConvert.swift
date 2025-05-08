//
//  SnakeCamelConvert.swift
//  CodableWrapper
//
//  Created by PAN on 2021/10/12.
//

import Foundation

extension String {
    private var isSnake: Bool {
        return contains("_")
    }

    // https://github.com/apple/swift-corelibs-foundation/blob/73d1943d0184040688a0f3ba5d66b61ea9e10a09/Sources/Foundation/JSONDecoder.swift#L103
    private func snakeToCamel() -> String {
        let stringKey = self
        guard !stringKey.isEmpty else { return stringKey }

        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }

        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore, stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }

        let keyRange = firstNonUnderscore ... lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex ..< firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore) ..< stringKey.endIndex

        let components = stringKey[keyRange].split(separator: "_")
        let joinedString: String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }

        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result: String
        if leadingUnderscoreRange.isEmpty, trailingUnderscoreRange.isEmpty {
            result = joinedString
        } else if !leadingUnderscoreRange.isEmpty, !trailingUnderscoreRange.isEmpty {
            // Both leading and trailing underscores
            result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
        } else if !leadingUnderscoreRange.isEmpty {
            // Just leading
            result = String(stringKey[leadingUnderscoreRange]) + joinedString
        } else {
            // Just trailing
            result = joinedString + String(stringKey[trailingUnderscoreRange])
        }
        return result
    }

    private func camelToSnake() -> String {
        var chars = Array(self)
        for (i, char) in chars.enumerated().reversed() {
            if char.isUppercase {
                chars[i] = String.Element(char.lowercased())
                if i > 0 {
                    chars.insert("_", at: i)
                }
            }
        }
        return String(chars)
    }

    func snakeCamelConvert() -> String? {
        let result: String
        if isSnake {
            result = snakeToCamel()
        } else {
            result = camelToSnake()
        }
        if self == result {
            return nil
        }
        return result
    }
}
