//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/18.
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


import SmartCodable

class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let dict1: [String: Any] = [
            "age": 10,
            "name": "Mccc",
            "location": [
                "province": "Jiang zhou",
                "city": "Su zhou",
            ]
            
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict1, options: []) {
            // Successfully converted Dictionary to Data
            print("JSON Data:", jsonData)
            
            do {
                let obj = try JSONDecoder().decode(Model.self, from: jsonData)
                print("obj = ", obj)

            } catch {
                print("error = ", error)
            }
            
            // If you want to convert it back to a String for debugging purposes
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String:", jsonString)
            }
        }
        
        if let model = Model.deserialize(from: dict1) {
            smartPrint(value: model)
            print("\n")
            let dict = model.toDictionary() ?? [:]
            print(dict)
        }
    }
}




extension Test3ViewController {
    struct Model: SmartCodable {
        var name: String = ""
        @IgnoredKey
        var ignore: String = ""
        @IgnoredKey
        var ignore2 = ""
        var age: Int = 0
        var location: Location?
    }
    
    struct Location: SmartCodable {
        var province: String = ""
        
        // 忽略解析
        @IgnoredKey
        var city: String = "area123"
    }
}


