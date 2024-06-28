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


整体验证一遍
1. 字典容器
2. 数组容器
3. 基础类型


class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .verbose
        
        let dict1: [String: Any] = [
            :
        ]
        
        let dict2: [String: Any] = [
            "arr": NSNull(),
            "optionalArr": NSNull(),
            "arr1": NSNull(),
            "optionalArr1": NSNull()
        ]
        
        let dict3: [String: Any] = [
            "arr": 1,
            "optionalArr": 2,
            "arr1": 3,
            "optionalArr1": 4
        ]
        
        let dict4: [String: Any] = [
            "arr": [[ "name": "mccc1" ], [ "name": "mccc2" ]],
            "optionalArr": [[ "name": "mccc1" ], [ "name": "mccc2" ]],
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
//        var arr: [Int] = []
//        var optionalArr: [Int]?
//        var optionalArr: [Int]? = [1, 1, 1]
        
//        var arr: [Int?] = []
//        var optionalArr: [Int?]?
//        var optionalArr: [Int?]? = [1, 1, 1]
        
//        @SmartAny
//        var arr: [Any] = []
//        @SmartAny
//        var optionalArr: [Any]?
        
        
        var arr: [SubModel] = []
        var optionalArr: [SubModel]?
    }
    
    struct SubModel: SmartCodable {
        var name: String?
    }
}
