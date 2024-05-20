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



class Test3ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = """
{"code":1,"data":{"index":"4","msg":"上传成功","size":1780},"msg":"success","rid":"Dg0S"}
"""
  
        if let model = mapModel([String: SmartAny].self, jsonString: json) {
            print(model)
        }
    }
    
    func mapModel<T: SmartCodable>(_ type: T.Type, jsonString: String) -> T? {
        guard let model = type.deserialize(from:jsonString) else {
            return nil
        }
        return model
    }
    
    struct ResponseData<T: SmartCodable>: SmartCodable{
        var code: Int = 0
        var msg: String = ""
        var data: T?
    }
}

