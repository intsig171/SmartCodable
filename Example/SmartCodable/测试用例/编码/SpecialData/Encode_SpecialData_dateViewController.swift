//
//  Encode_SpecialData_dateViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/6/6.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable



class Encode_SpecialData_dateViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        let dict: [String: Any] = [
            "a": "2024-06-06",
            "b": "1123"
        ]

        guard let adaptive = Model.deserialize(from: dict) else { return }
        
        smartPrint(value: adaptive)
        
        if let to = adaptive.toDictionary() {
            print(to)
        }
    }
}


extension Encode_SpecialData_dateViewController {
    struct Model: SmartCodable {
        var a: Date?
        var b: Date?
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            let tf = DateFormatter()
            tf.dateFormat = "yyyy-MM-dd"
            return [
                CodingKeys.a <--- SmartDateFormatTransformer(tf),
                CodingKeys.b <--- SmartDateFormatTransformer(tf)
            ]
        }
    }
}
