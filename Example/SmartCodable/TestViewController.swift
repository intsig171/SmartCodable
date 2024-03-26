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
        
        
        let dict: [String: Any] = [
            "name": "Mccc"
        ]

        guard let model1 = HandyModel.deserialize(from: dict) else { return }
        print(model1)
        
        guard let model = SmartModel.deserialize(from: dict) else { return }
        print(model)
    }
}

extension TestViewController {
    struct HandyModel: HandyJSON {
        var name: String = ""
    }
    
    struct SmartModel: SmartCodable {
        var name: String = ""
    }
}
