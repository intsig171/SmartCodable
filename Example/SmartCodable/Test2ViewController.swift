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


import SmartCodable

class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model1 = ModelT4(age: "123")
        let model2 = ModelT4(age: "123")
        
        if model1 == model2 {
            print("==")
        }
    }
}
class ModelT4: NSObject {
    
    var age: String
    
    init(age: String) {
        self.age = age
    }
    
    static func == (lhs: ModelT4, rhs: ModelT4) -> Bool {
        return lhs.age == rhs.age
    }
}
