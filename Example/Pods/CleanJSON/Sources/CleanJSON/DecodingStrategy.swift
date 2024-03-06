// 
//  DecodingStrategy.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/12/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

extension CleanJSONDecoder {
    
    public enum KeyNotFoundDecodingStrategy {
        case `throw`
        case useDefaultValue
    }
    
    public enum ValueNotFoundDecodingStrategy {
        case `throw`
        case useDefaultValue
        case custom(JSONAdapter)
    }
    
    public enum JSONStringDecodingStrategy {
        case containsKeys([CodingKey])
        case all
    }
}

extension CleanJSONDecoder {
    
    public struct NestedContainerDecodingStrategy {
        
        public enum KeyNotFound {
            case `throw`
            case useEmptyContainer
        }
        
        public enum ValueNotFound {
            case `throw`
            case useEmptyContainer
        }
        
        public enum TypeMismatch {
            case `throw`
            case useEmptyContainer
        }
        
        public var keyNotFound: KeyNotFound
        
        public var valueNotFound: ValueNotFound
        
        public var typeMismatch: TypeMismatch
        
        public init(
            keyNotFound: KeyNotFound = .useEmptyContainer,
            valueNotFound: ValueNotFound = .useEmptyContainer,
            typeMismatch: TypeMismatch = .useEmptyContainer
        ) {
            self.keyNotFound = keyNotFound
            self.valueNotFound = valueNotFound
            self.typeMismatch = typeMismatch
        }
    }
}
