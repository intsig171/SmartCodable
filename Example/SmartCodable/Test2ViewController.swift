//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint
import Combine

class Test2ViewController: BaseViewController {
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
//            "name": "mccc",
            "age": 30,
            "info": [
                "name": "mccc111"
            ],
            "sub": [
                "subname": "qilin",
                "subage": 3,
                "info": [
                    "name": "qilin111"
                ],
            ]

        ]
        let model = Model.deserialize(from: dict)
        BTPrint.print(model)

        print("\n")
        
        let tranDict = model?.toDictionary() ?? [:]
        BTPrint.print(tranDict)
    }
}

struct Model: SmartCodable {
    var name: String = ""
    var age: Int = 0
    var sub: SubModel = SubModel()
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.name <--- "info.name"
        ]
    }
}

struct SubModel: SmartCodable {
    var subname: String = ""
    var subage: Int = 0
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.subname <--- "info.name"
        ]
    }
}
