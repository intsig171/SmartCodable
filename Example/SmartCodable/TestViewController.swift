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



/** 字典的值情况
 * 无key
 * 值为null
 * 值类型错误
 */

/** 字典的类型情况
 * 非可选基础字典
 * 可选基础字典
 *
 * 非可续Model
 * 可选Model
 *
 * 使用 SmartAny 修饰
 * 使用 SmartPlat 修饰
 *
 */





class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
        

        
        let arr = [
            ["name": "mccc1", "age": 20, "hobby": [1, 2, 3, "4"]],
            ["name": "mccc2", "age": 30],
        ]
        
        
        if let model = [FeedModel].deserialize(from: arr) {
            smartPrint(value: model)
        }

    }
    //模型
    struct FeedModel: SmartCodable {
        var name: String = ""
        var age: Int?
        var hobby: [String] = []
    }
}
