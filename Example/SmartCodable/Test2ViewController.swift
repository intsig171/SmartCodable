//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON


class Test2ViewController: BaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let dict: [String: Any] = [
            "sub": ["name": "Mccc"]
        ]

        if let jsonObject = Model.deserialize(from: dict) {
            print(jsonObject)
        }
    }
        
    struct Model: SmartCodable {

        var sub: [[String: String]]?
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.sub <--- DictTranformer()
            ]
        }
    }
    
    struct SubModel: SmartCodable {
        var name: Int = 123
    }
}

struct DictTranformer: ValueTransformable {
    func transformFromJSON(_ value: Any?) -> [[String : String]]? {
        return [
            [
                "name": "Mccc"
            ]
        ]
    }
    
    func transformToJSON(_ value: [[String : String]]?) -> [String : String]? {
        ["name": "Mccc"]
    }
    
    typealias Object = [[String: String]]
    
    typealias JSON = [String: String]
    
    
}
