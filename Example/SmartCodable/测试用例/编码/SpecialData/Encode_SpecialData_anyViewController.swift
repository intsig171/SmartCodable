//
//  Encode_SpecialData_anyViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/6/6.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class Encode_SpecialData_anyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        let dict: [String: Any] = [
            "a": "one",
            "b": [1, 2, 3, 4],
            "c": ["a": 1, "b": 2]
        ]

        guard let adaptive = Model.deserialize(from: dict) else { return }
        
        smartPrint(value: adaptive)
        
        if let to = adaptive.toDictionary() {
            print(to)
        }
    }
}


extension Encode_SpecialData_anyViewController {
    struct Model: SmartCodable {
        var a: SmartAny?
        var b: [SmartAny]?
        var c: [String: SmartAny]?
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            return [
                CodingKeys.a <--- OneTranformer(),
                CodingKeys.b <--- TwoTranformer(),
                CodingKeys.c <--- ThreeTranformer()

            ]
        }
    }
    
    struct OneTranformer: ValueTransformable {
        
        typealias Object = SmartAny
        typealias JSON = Any
        
        func transformToJSON(_ value: SmartAny) -> Any? {
            return value.peel
        }
        
        func transformFromJSON(_ value: Any) -> SmartAny? {
            return SmartAny(from: value)
        }
    }
    
    
    struct TwoTranformer: ValueTransformable {
        
        typealias Object = [SmartAny]
        typealias JSON = Any
        
        func transformToJSON(_ value: [SmartAny]) -> Any? {
            return value.peel
        }
        
        func transformFromJSON(_ value: Any) -> [SmartAny]? {
            return [.string("mccc")]
        }
    }
    
    
    struct ThreeTranformer: ValueTransformable {
        
        typealias Object = [String: SmartAny]
        typealias JSON = Any
        
        func transformToJSON(_ value: [String: SmartAny]) -> Any? {
            return value.peel
        }
        
        func transformFromJSON(_ value: Any) -> [String: SmartAny]? {
            return ["key": .string("value")]
        }
    }
}
