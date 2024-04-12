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

        let dict1: [String: Any] = [
            "data": [
                "int": 3,
                "double": 5.5
            ]
        ]

        guard let model = Model.deserialize(from: dict1) else { return }
                
        guard let data = model.data?.peel else { return }

        if let int = data["int"]  as? Int {
            print("字段 int 的值为 \(int)")
        }

        if let double = data["int"]  as? Double {
            print("字段 int 的值为 \(double)")
        }

        if let int = data["double"] as? Int {
            print("字段 double 的值为 \(int)")
        }
    }
}



extension TestViewController {
    
    struct Model: SmartCodable {
        var data: [String: SmartAny]?
    }
}

