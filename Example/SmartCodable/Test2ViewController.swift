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
            "name": "mccc",
            "subModel": "mccc111",

        ]
        let model = Model.deserialize(from: dict)
        print(model?.subModel?.rawValue)
        
        let dict1 = model?.toDictionary()
        print(dict1)

    }
    
    struct Model: SmartCodable {
        var name: String = ""
        @SmartPublished
        var subModel: TestEnum?
        
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.name <--- FastTransformer<String, String>(fromJSON: { json in
                    "abc"
                }),
                CodingKeys.subModel <--- FastTransformer<TestEnum, String>(fromJSON: { json in
                    TestEnum.man
                }),
            ]
        }
    }
    
    enum TestEnum: String, SmartCaseDefaultable {
    case man
    }
    
    struct SubModel: SmartCodable {
        var name: String = ""
        
    }
}
