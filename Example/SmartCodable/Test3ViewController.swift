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



class Test3ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dict = [
            "color": "666666",
            "date": "2024-04-18"
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
        
        
        let di = model.toDictionary() ?? [:]
        print(di)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let v = df.string(from: model.date!)
        print(v)

    }
    
    struct Model: SmartCodable {
        var color: SmartColor = .color(.red)
        var date: Date?
        
        
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return [
                CodingKeys.date <--- SmartDateFormatTransformer(df)
            ]
        }
    }
}

