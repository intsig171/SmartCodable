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
                   
           let dict: [String: Any] = [
               "code": "200",
               "data": [
                   "name": "mccc",
                   "height": NSNull(),
                   "weight": NSNull(),
                   "id": 12,
                   "age": 43,
                   "icon": "1231231122",
                   "bid": "12312312",
                   "r1": 0,
                   "dis": 321123,
                   "se": 1
               ],
               "msg": ""
           ]
           
           let dict1: [String: Any] = [
               "code": "200",
               "data": [1802527796438790146, 1802527796438793206],
               "msg": ""
           ]
           
           if let model = demo.deserialize(from: dict) {
               print(model.data)
               print(model.toJSONString(prettyPrint: true) ?? "")
           }
       
           if let model_1 = demo1.deserialize(from: dict1) {
               print(model_1.data)
               print(model_1.toJSONString(prettyPrint: true) ?? "")
           }

//           if let model_2 = demo.deserialize(from: dict1) {
//               print(model_2.data)
//               print(model_2.toJSONString(prettyPrint: true) ?? "")
//           }

       }
           
       struct demo: SmartCodable {
           public var code: String = "0"
           public var msg: String = ""
           @SmartAny
           public var data: Any?
       }
       
       struct demo1: SmartCodable {
           public var code: String = "0"
           public var msg: String = ""
           public var data: [Int64] = .init()
       }
}

