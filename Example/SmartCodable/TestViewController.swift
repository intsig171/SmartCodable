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


class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
//        
//        guard let model = HandyModel.deserialize(from: dict) else { return }
//        print(model)
        

        let dict1: [String: Any] = [
            "date": "2024-04-07",
            "date2": 1712491290,
            "sub": [
                "date2": 1712491290,
            ]
        ]
        guard let model1 = SmartModel.deserialize(from: dict1) else { return }
        print(model1)
    }
}

extension TestViewController {
    
    struct SmartModel: SmartCodable {
        var date1: Date?
        var date2: Date?
        
        static func mapping() -> [SmartKeyTransformer]? {
            [
                CodingKeys.date1 <--- "date"
            ]
        }
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            return [
                CodingKeys.date2 <--- SmartDateTransformer(),
                CodingKeys.date1 <--- SmartDateFormatTransformer(format)
            ]
        }
    }
    
    struct SmartSubModel: SmartCodable {

        var date2: Date?
        
        static func mapping() -> [SmartKeyTransformer]? {
            [
                CodingKeys.date2 <--- "date2"
            ]
        }
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.date2 <--- SmartDateTransformer()
            ]
        }
    }
}

