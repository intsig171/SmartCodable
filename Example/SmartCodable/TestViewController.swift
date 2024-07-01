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
        
        let jsonStr = """
        {
            "age": "18",
            "weight": "65.4",
            "sex": "1"
        }
        """
        if let model = ZJSmartCodableModel.deserialize(from: jsonStr) {
            smartPrint(value: model)
        }
    }
    //模型
    struct ZJSmartCodableModel: SmartCodable {
        var age: Int?
        var weight: Double?
        var sex: Bool?
    }
}
