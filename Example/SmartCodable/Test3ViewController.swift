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
            "a": "aa",
            "b": 100,
            "longitude": "3",
            "latitude": 4
        }
        """
        if let model = SubModel.deserialize(from: jsonString) {
            smartPrint(value: model.c)
        }
    }
    struct SuperModel: SmartCodable {
        var longitude: Double?
        var latitude: Double?
    }
    struct SubModel: SmartCodable {
        var a: String?
        var b: Int?
        
        @SmartFlat
        var c: SuperModel?
    }
}




