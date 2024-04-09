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
            "date1": "2024-04-07",
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
        var sub: SmartSubModel?
    }
    
    struct SmartSubModel: SmartCodable {

        var date2: Date?
    }
}

