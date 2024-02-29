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

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let dict1: [String: Any] = [
//            "arr2": NSNull(),
//            "arr3": 1,
//            "arr4": [2],
            
            "arr6": 123,
//            "arr7": 1,
//            "arr8": [2],
        ]
        
        if let model = Test1_1DictModel.deserialize(dict: dict1) {
//            print(model.r)
            print(model)
        }

        

    }
}

struct Test1_1DictModel: SmartCodable {
    
//    var arr1: [Int] = []
//    var arr2: [Int] = []
//    var arr3: [Int] = []
//    var arr4: [Int] = []
//
//    var arr5: [Int]?
    var arr6: [Int]?
//    var arr7: [Int]?
//    var arr8: [Int]?
}

