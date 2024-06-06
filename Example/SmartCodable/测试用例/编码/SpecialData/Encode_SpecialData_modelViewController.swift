//
//  Encode_SpecialData_modelViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/6/6.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable



class Encode_SpecialData_modelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        let dict: [String: Any] = [
            "a": [
                "name": "haha"
            ]
        ]

        guard let adaptive = Model.deserialize(from: dict) else { return }
        
        smartPrint(value: adaptive)
        
        if let to = adaptive.toDictionary() {
            print(to)
        }
    }
}


extension Encode_SpecialData_modelViewController {
    struct Model: SmartCodable {
        var a: SubModel?
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.a <--- Tranformer()
            ]
        }
    }
    
    struct SubModel: SmartCodable {
        var name: String = ""
    }
    
    struct Tranformer: ValueTransformable {
        
        typealias Object = SubModel
        typealias JSON = [String: Any]
        
        func transformToJSON(_ value: SubModel) -> [String: Any]? {
            return value.toDictionary()
        }
        
        func transformFromJSON(_ value: Any) -> SubModel? {
            return SubModel.init(name: "Mccc")
        }
    }
}
