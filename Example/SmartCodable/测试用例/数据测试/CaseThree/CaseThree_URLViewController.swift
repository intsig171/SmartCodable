//
//  CaseThree_URLViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class CaseThree_URLViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 浮点数的异常数据（Nan & inf）处理，不再提供demo。
        /// 底层将这两个值当成了字符串处理，遇到了就提供默认值。

        
        let dict: [String: Any] = [
            "a": "0",
            "b": "Mccc",
            "c": [],
            "d": NSNull(),
            "e": "www.baidu.com",
        ]
  
        
        if let url = URL(string: "0") {
            print(url.absoluteString)
        }
        
        
        if let model = URLModel.deserialize(dict: dict) {
            print(model)
        
        }
        
    }
    
    struct URLModel: SmartCodable {
        var a: URL?
        var b: URL?
        var c: URL?
        var d: URL?
        var e: URL?
    }
}
