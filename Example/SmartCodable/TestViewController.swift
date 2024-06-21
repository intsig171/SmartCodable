//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint

class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonString = """
        {
            "a": "aa",
            "b": 100,
            "c": {
                "longitude": 300,
                "latitude": 400
            },

            "longitude": 3,
            "latitude": 4
        }
        """
        if let model = SubClass.deserialize(from: jsonString) {
            smartPrint(value: model.c)
        }
    }
    struct SuperClass: SmartCodable {
        var longitude: Double?
        var latitude: Double?
        
        var a: String?
        var b: Int?
    }
    struct SubClass: SmartCodable {
        var a: String?
        var b: Int?
        
        @SmartFlat
        var c: SuperClass?
    }
}
