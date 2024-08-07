//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let subModel = SubModel()
        let model = Model(type: 2, data: subModel)
        
        let json = model.toJSONString()
        
        print(json)
    }
    
    class Model: SmartCodable {
        init(type: Int, data: Any) {
            self.type = type
            self.data = data
        }
        
        var type: Int?
        
        @SmartAny
        var data: Any?
        
        required init() { }
    }
    
    
    
    class SubModel: SmartCodable {
        var name: String = "mccc"
        required init() { }
    }
}
