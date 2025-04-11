//
//  JSONFuture.swift
//  BTBubble
//
//  Created by Mccc on 2024/6/3.
//

import Foundation
enum JSONFuture {
    case value(JSONValue)
    case encoder(JSONEncoderImpl)
    case nestedArray(RefArray)
    case nestedObject(RefObject)

    class RefArray {
        private(set) var array: [JSONFuture] = []

        init() {
            self.array.reserveCapacity(10)
        }

        @inline(__always) func append(_ element: JSONValue) {
            self.array.append(.value(element))
        }

        @inline(__always) func append(_ encoder: JSONEncoderImpl) {
            self.array.append(.encoder(encoder))
        }

        @inline(__always) func appendArray() -> RefArray {
            let array = RefArray()
            self.array.append(.nestedArray(array))
            return array
        }

        @inline(__always) func appendObject() -> RefObject {
            let object = RefObject()
            self.array.append(.nestedObject(object))
            return object
        }

        var values: [JSONValue] {
            self.array.map { (future) -> JSONValue in
                switch future {
                case .value(let value):
                    return value
                case .nestedArray(let array):
                    return .array(array.values)
                case .nestedObject(let object):
                    return .object(object.values)
                case .encoder(let encoder):
                    return encoder.value ?? .object([:])
                }
            }
        }
    }

    class RefObject {
        private(set) var dict: [String: JSONFuture] = [:]

        init() {
            self.dict.reserveCapacity(20)
        }

        @inline(__always) func set(_ value: JSONValue, for key: String) {
            self.dict[key] = .value(value)
        }

        @inline(__always) func setArray(for key: String) -> RefArray {
            switch self.dict[key] {
            case .encoder:
                preconditionFailure("For key \"\(key)\" an encoder has already been created.")
            case .nestedObject:
                preconditionFailure("For key \"\(key)\" a keyed container has already been created.")
            case .nestedArray(let array):
                return array
            case .none, .value:
                let array = RefArray()
                dict[key] = .nestedArray(array)
                return array
            }
        }

        @inline(__always) func setObject(for key: String) -> RefObject {
            switch self.dict[key] {
            case .encoder:
                preconditionFailure("For key \"\(key)\" an encoder has already been created.")
            case .nestedObject(let object):
                return object
            case .nestedArray:
                preconditionFailure("For key \"\(key)\" a unkeyed container has already been created.")
            case .none, .value:
                let object = RefObject()
                dict[key] = .nestedObject(object)
                return object
            }
        }

        @inline(__always) func set(_ encoder: JSONEncoderImpl, for key: String) {
            switch self.dict[key] {
            case .encoder:
                preconditionFailure("For key \"\(key)\" an encoder has already been created.")
            case .nestedObject:
                preconditionFailure("For key \"\(key)\" a keyed container has already been created.")
            case .nestedArray:
                preconditionFailure("For key \"\(key)\" a unkeyed container has already been created.")
            case .none, .value:
                dict[key] = .encoder(encoder)
            }
        }

        var values: [String: JSONValue] {
            self.dict.mapValues { (future) -> JSONValue in
                switch future {
                case .value(let value):
                    return value
                case .nestedArray(let array):
                    return .array(array.values)
                case .nestedObject(let object):
                    return .object(object.values)
                case .encoder(let encoder):
                    return encoder.value ?? .object([:])
                }
            }
        }
    }
}
