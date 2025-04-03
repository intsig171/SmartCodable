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
            "date": "2024-06-06",
            "data": "aHR0cHM6Ly93d3cucWl4aW4uY29t",
            "url": "https://www.baidu.com"
        ]
        
        let tf = DateFormatter()
        tf.dateFormat = "yyyy-MM-dd"
        let model = Model.deserialize(from: dict, options: [.date(.formatted(tf))])
        print(model)
        
    }

    
    struct Model: SmartCodable {
        var date: Date?
        var data: Data?
        var url: URL?
    }
}



