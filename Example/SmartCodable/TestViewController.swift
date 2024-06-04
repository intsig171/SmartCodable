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

import SmartCodable

class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
//            "date": "2024-06-03",
            "currentDate": 739107587,
            "age": 100
        ]
        
        if let model = Model.deserialize(from: dict) {
            print(model)
            
            let dict = model.toDictionary()
            print(dict)
        }

    }
    
    struct Model: SmartCodable {
        var date: Date = Date()
        var age: Int?
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return [
                CodingKeys.date <--- SmartDateFormatTransformer(df)
//                CodingKeys.date <--- SmartDateTransformer()
            ]
        }
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.date <--- "currentDate"
            ]
        }
        
    }
}

