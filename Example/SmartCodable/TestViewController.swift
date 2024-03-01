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

struct BaseFeed123: Codable {
    var name: String = ""
//    var age: Int = 0
//    var sex: Bool = false
}

class TestViewController : BaseViewController {
    
    
//    func todo() throws -> Int {
//        throw DecodingError.keyNotFound(CodingKey.init(intValue: 1)!, DecodingError.Context.init(codingPath: [], debugDescription: ""))
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let value = try todo() {
//            print(value)
//        } else {
//            print("未执行")
//        }
        
        

        
        let dict1: [String: Any] = [
//            "arr2": NSNull(),
//            "arr3": 1,
//            "arr4": [2],
            
            "arr6": 123,
//            "arr7": 1,
//            "arr8": [2],
        ]
        
        if let model = Test1_1DictModel.deserialize(dict: dict1) {
            print(model)
        }

//        let v = dict1.decode(type: Test1_1DictModel.self)
//        print(v)

    }
}

struct Test1_1DictModel: SmartCodable {
    
//    var arr1: [Int] = []
//    var arr2: [Int] = []
//    var arr3: Int = 0
//    var arr4: [Int] = []
//
//    var arr5: [Int]?
    var arr6: Test2?
//    var arr7: [Int]?
//    var arr8: [Int]?
}

struct Test2: SmartCodable {
    var name: String = ""
}
