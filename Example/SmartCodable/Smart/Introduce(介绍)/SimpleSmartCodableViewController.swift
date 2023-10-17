//
//  SimpleSmartCodableViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class SimpleSmartCodableViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: String] = ["name": "xiaoming"]
        let arr = [dict, dict]
        guard let models = [SimpleSmartCodableModel].deserialize(array: arr) else { return }
        print(models)
    }
}




struct SimpleSmartCodableModel: SmartCodable {
    var name: String = ""
}


