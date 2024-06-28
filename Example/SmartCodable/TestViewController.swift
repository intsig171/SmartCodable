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
import HandyJSON
import CleanJSON
import BTPrint

class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
        
        let dict1: [String: Any] = [
            :
        ]
        
        let dict2: [String: Any] = [
            "dict": NSNull(),
            "optionalDict": NSNull()
        ]
        
        let dict3: [String: Any] = [
            "dict": 1,
            "optionalDict":2
        ]
        
        let dict4: [String: Any] = [
            "dict": [ "name": "mccc" ],
            "optionalDict": [ "name": "mccc" ],
        ]
        
        
        
        print("-------------- 无key")
        if let model = FeedModel.deserialize(from: dict1) {
            smartPrint(value: model)
        }
        
        print("-------------- null")
        if let model = FeedModel.deserialize(from: dict2) {
            smartPrint(value: model)
        }
        
        print("-------------- 类型错误")
        if let model = FeedModel.deserialize(from: dict3) {
            smartPrint(value: model)
        }
        
        print("-------------- 解析正确的")
        if let model = FeedModel.deserialize(from: dict4) {
            smartPrint(value: model)
        }

    }
    //模型
    struct FeedModel: SmartCodable {
//        var dict: [String: String] = [:]
//        var optionalDict: [String: String]?
        
        @SmartAny
        var dict: [String: Any?] = [:]
        @SmartAny
        var optionalDict: [String: Any]?
        
        
//        var dict: SubModel = SubModel()
//        var optionalDict: SubModel?
    }
    
    struct SubModel: SmartCodable {
        var name: String?
    }
}
