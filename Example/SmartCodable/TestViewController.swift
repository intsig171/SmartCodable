//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint


/** 字典的值情况
 1. @Published 修饰的属性的解析。
 2. 继承关系！！！！
 *
 */


/**
 V4.1.12 发布公告
 1. 【新功能】支持Combine，允许@Published修饰的属性解析。
 2. 【新功能】支持@igonreKey修饰的属性在encode时，不出现在json中（屏蔽这个属性key）
 3. 【新功能】支持encode时候的options，同decode的options使用。
 4. 【优化】Data类型在decode和encode时，只能使用base64解析.
 */


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dict: [String: Any] = [
            "a": "mccc",
            "b": [],
            "sub": [
                "a": "Mccc"
            ],
            "sub2s": [[
                "d": []
            ],[
                "sub2_a": []
            ]]
        ]
        
        let dict1: [String: Any] = [
            "b": "mccc",
            "c": [],
            "sub": [
                "sub_a": "Mccc"
            ],
            "sub2s": [[
                "sub2_a": "Mccc"
            ],[
                "sub2_a": NSNull()
            ]]
        ]
        
    
        
//         let model = Model.deserialize(from: dict)
        let model = [Model].deserialize(from: [dict, dict1])

    }
    
    
    struct Model: SmartCodable {
        var sub: SubModel = SubModel()
        var sub2s: [SubTwoModel] = []

        var a: Int = 0
        var b: Int = 0
        var c: Int = 0
    }

    struct SubModel: SmartCodable {
        var sub_a: Int = 0
        var sub_b: Int = 0
        var sub_c: Int = 0
    }
    
    struct SubTwoModel: SmartCodable {
        var sub2_a: Int = 0
        var sub2_b: Int = 0
        var sub2_c: Int = 0
    }
}

