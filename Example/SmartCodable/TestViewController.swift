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


/** todo
 1. 【done】issue，数组model属性（或非model的数组），遇到json str。
 2. 【done】其他类型新增解析策略
 3. 【done】验证解析失败使用初始值的场景。并看看value的自定义解析策略。
 4. 【done】SmartAny的解析失败的验证。
 5. 关联值的解析支持。
 
 */


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [:]
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()
        
        queue.async(group: group) {
            if let model = NewModel.deserialize(from: dict) {
                //            print(model)
            }
        }
        
        queue.async(group: group) {
            print("\n\n 开始解析old")
            
            if let model = OldModel.deserialize(from: dict) {
                //            print(model)
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("Both methods are completed.")
        }
    }
}

struct NewModel: SmartCodable {
    var newa: String = ""
    var newb: String = ""
    var newc: String = ""
    var newd: String = ""
    var newe: String = ""
    var newf: String = ""
    var newSub: NewsubModel = NewsubModel()
}

struct NewsubModel: SmartCodable {
    var newname: String = ""
    
}


struct OldModel: SmartCodable {
    var olda: String = ""
    var oldb: String = ""
    var oldc: String = ""
    var oldd: String = ""
    var olde: String = ""
    var oldf: String = ""
    var oldSub = OldsubModel()
}

struct OldsubModel: SmartCodable {
    var oldname: String = ""
}
