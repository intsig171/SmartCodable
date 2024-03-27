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
            "nick_name": "Mccc",
            "Age": 10,
            "sub": [
                "Name": "小明",
                "Age": 20
            ]
        ]
        
        let option: JSONDecoder.SmartOption = .KeyStrategy(.convertFirstLetterToLowercase)
        let option1: JSONDecoder.SmartOption = .KeyStrategy(.convertFromSnakeCase)

        guard let model = SmartModel.deserialize(from: dict, options: [option1, option]) else { return }
        print(model)
    }
}

extension TestViewController {
    
    struct HandyModel: HandyJSON {
        var name: String = ""
    }
    
    
    struct SmartModel: SmartCodable {
        var nickName: String = ""
        var age: Int = 0
        var sub: SmartSubModel?
    }
    
    struct SmartSubModel: SmartCodable {
        var name: String = ""
        var age: Int = 0
    }
}
