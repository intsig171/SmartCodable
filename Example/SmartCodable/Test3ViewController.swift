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
        
  
        request(model:ResponseData<Dictionary<String,SmartAny>>.self) { response in
            print(response)
        }
    }
    
    struct ResponseData<T: SmartCodable>: SmartCodable{
        var code: Int = 0
        var msg: String = ""
        var data: T?
    }

    func request<T: SmartCodable>(model: T.Type, completion:((_ response:T?) -> Void)?){
        let json = """
        {"code":1, "data":{ "index": "4", "msg": " EftI", "size":1780}, "msg": "success", "rid":"DgOS" }
        """
        if let model = model.deserialize(from:json) {
            completion?(model)
        }
    }
}

