//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON
import CleanJSON




class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonString = """
        {
            "46": "aa",
            "47": 100,
        }
        """
        if let model = SubModel.deserialize(from: jsonString) {
            smartPrint(value: model)
        }
    }

    struct SubModel: SmartCodable {
        var a46: String?
        var b47: Int?
        
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.a46 <--- ["1314520", "5201314"],
                CodingKeys.b47 <--- "47",
            ]
        }
        
    }
}




