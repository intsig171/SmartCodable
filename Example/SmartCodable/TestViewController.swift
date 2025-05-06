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
        
        let dict: [String: Any] =  [
            "color": "000000",
            "color1": "ffffff",
            "color2": "#000000",
            "color3": "0xffffff",
            "date": "2024-02-01",
            "date1": "2024-02-01 11:11",
            "date2": "2024-02-01 11:11:11",
            "date3": "1746501765",
            "date4": "1746501764000"
        ]

        let model = Model.deserialize(from: dict)
//        print(model?.color)
//        print(model?.color2)
//        print(model?.color3)
        
        print(model?.date)
//        print(model?.date1)
//        print(model?.date2)
//        print(model?.date3)
//        print(model?.date4)
        
        print("\n\n")
        
        
        let transDict = model?.toJSONString(prettyPrint: true) ?? ""
        print(transDict)

    }

    
    struct Model: SmartCodable {
//        
//        @SmartHexColor
//        var color: UIColor?
//        
//        @SmartHexColor
//        var color1: UIColor?
//        @SmartHexColor
//        var color2: UIColor?
//        @SmartHexColor
//        var color3: UIColor?
        
        
//        @SmartDate
        var date: Date?
//        @SmartDate
//        var date1: Date?
//        @SmartDate
//        var date2: Date?
//        @SmartDate
//        var date3: Date?
//        @SmartDate
//        var date4: Date?
        
        
        
//        static func mappingForValue() -> [SmartValueTransformer]? {
//            [
//                CodingKeys.height <--- SmartDateTransformer(isMilliseconds: true)
//            ]
//        }
    }
}



