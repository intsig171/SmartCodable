import Foundation

public extension KeyedEncodingContainer where K == AnyCodingKey {
    func encode<Value: Encodable>(value: Value,
                                  keys: [String],
                                  nestedKeys: [String]) throws {
        // check if value is nil
        if case Optional<Any>.none = (value as Any) {
            return
        }
        if !nestedKeys.isEmpty {
            return try encodeNestedKey(value: value, key: nestedKeys[0])
        } else {
            var mutatingSelf = self
            return try encodeNormakKey(value: value, key: keys[0], container: &mutatingSelf)
        }
    }
}

private extension KeyedEncodingContainer where K == AnyCodingKey {
    func encodeNestedKey(value: Encodable, key: String) throws {
        var keyComps = key.components(separatedBy: ".")
        let lastKey = keyComps.removeLast()
        var nestedContainer: KeyedEncodingContainer<AnyCodingKey>? = self
        for keyComp in keyComps {
            nestedContainer = nestedContainer?.nestedContainer(keyedBy: AnyCodingKey.self, forKey: .init(stringValue: keyComp)!)
        }
        if var nestedContainer = nestedContainer {
            try encodeNormakKey(value: value, key: lastKey, container: &nestedContainer)
        }
    }

    func encodeNormakKey(value: Encodable, key: String, container: inout KeyedEncodingContainer<AnyCodingKey>) throws {
        let codingKey = AnyCodingKey(stringValue: key)!
        try container.encode(value, forKey: codingKey)
    }
}
