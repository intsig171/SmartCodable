//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON
import CleanJSON


/** 测试内容项
 1. 默认值的使用是否正常
 2. mappingForValue是否正常。
 3. 
 */


class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let string = "{\"id\":1, \"sex\":{\"id\":1}}"
        
        if let model = Model.deserialize(from: string) {
            smartPrint(value: model)
        }
        
    }
    
    struct Model: SmartCodable {
     var id: Int = 0
        var sex: SubModel = SubModel()
    }
    
    struct SubModel: SmartCodable {
        var id : Int = 0
    }
}
