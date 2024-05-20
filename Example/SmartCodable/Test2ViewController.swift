//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON


class Test2ViewController: BaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        let dict: [String: Any] = [
            "models": 1
        ]
        
        let arr = [1, 2, 3]
        
        
        if let jsonObject = [Model].deserialize(from: dict) {
            print(jsonObject)
        }
    }
    

    
    struct Model: SmartCodable {
        var models: [SubModel] = []
    }
    
    struct SubModel: SmartCodable {
        var name: String = ""
    }
}
