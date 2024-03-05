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



class TestViewController : BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        

        let dict: [String: Any] = [
            "name": "Mccc",
        ]

        if let model = Model.deserialize(dict: dict) {
            print(model)
            print(model.name)
        }
    }
}


extension TestViewController {
    struct Model: SmartCodable {
        var name: String?
    }

}


