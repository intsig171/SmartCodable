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
        
        let jsonString = """
        {
            "array": [
                null,
                {
                "element": 3
                }
            ]
        }
        """
        
        let jsonString1 = """
        {
            "array": [
                null,
            ]
        }
        """
        
        if let model = OptionalArrayElementsExample.deserialize(from: jsonString) {
            smartPrint(value: model)
        }
    }
    struct OptionalArrayElementsExample: SmartCodable {
        @SmartFlat
        var array: [ArrayElement] = []
    }

    struct ArrayElement: SmartCodable {
        var element: Int = 0
    }
}
