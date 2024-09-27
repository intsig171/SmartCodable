//
//  SmartKeyDecodingStrategy.swift
//  SmartCodable
//
//  Created by Mccc on 2024/3/27.
//

import Foundation

extension JSONDecoder {
    public enum SmartDataDecodingStrategy : Sendable {
        /// Decode the `Data` from a Base64-encoded string. This is the default strategy.
        case base64
    }
}



extension JSONDecoder {
    public enum SmartKeyDecodingStrategy : Sendable {

        /// Use the keys specified by each type. This is the default strategy.
        case useDefaultKeys

        /// Convert from "snake_case_keys" to "camelCaseKeys" before attempting to match a key with the one specified by each type.
        ///
        /// The conversion to upper case uses `Locale.system`, also known as the ICU "root" locale. This means the result is consistent regardless of the current user's locale and language preferences.
        ///
        /// Converting from snake case to camel case:
        /// 1. Capitalizes the word starting after each `_`
        /// 2. Removes all `_`
        /// 3. Preserves starting and ending `_` (as these are often used to indicate private variables or other metadata).
        /// For example, `one_two_three` becomes `oneTwoThree`. `_one_two_three_` becomes `_oneTwoThree_`.
        ///
        /// - Note: Using a key decoding strategy has a nominal performance cost, as each string key has to be inspected for the `_` character.
        case fromSnakeCase
        
        /// Convert the first letter of the key to lower case before attempting to match a key with the one specified by each type.
        /// For example, `OneTwoThree` becomes `oneTwoThree`.
        ///
        /// - Note: This strategy should be used with caution, especially if the key's first letter is intended to be uppercase for distinguishing purposes. It also incurs a nominal performance cost, as the first character of each key needs to be inspected and possibly modified.
        case firstLetterLower
        
        /// Convert the first letter of the key to upper case before attempting to match a key with the one specified by each type.
        /// For example, `oneTwoThree` becomes `OneTwoThree`.
        ///
        /// - Note: This strategy should be used when the keys are expected to start with a lowercase letter and need to be converted to start with an uppercase letter. It incurs a nominal performance cost, as the first character of each key needs to be inspected and possibly modified.
        case firstLetterUpper
    }
}

extension JSONDecoder.SmartKeyDecodingStrategy {
    
    
    
    static func _convertFirstLetterToLowercase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }

        return stringKey.prefix(1).lowercased() + stringKey.dropFirst()
    }
    
    static func _convertFirstLetterToUppercase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }

        return stringKey.prefix(1).uppercased() + stringKey.dropFirst()
    }
    
    static func _convertFromSnakeCase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }
        
        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }
        
        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }
        
        let keyRange = firstNonUnderscore...lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex
        
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
        if leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty {
            result = joinedString
        } else if !leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty {
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
}

