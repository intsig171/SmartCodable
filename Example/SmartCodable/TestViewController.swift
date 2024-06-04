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

var snapArr: [String] = []

struct Log {
    static func save(name: String) {
        snapArr.append(name)
    }
}


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [:]
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()
        
        queue.async(group: group) {
//            Log.save(name: "abc")
            if let model = NewModel.deserialize(from: dict) {
                //            print(model)
            }
        }
        
        queue.async(group: group) {
//            Log.save(name: "abcd")
            if let model = OldModel.deserialize(from: dict) {
                //            print(model)
            }
        }
//        
//        queue.async(group: group) {
////            Log.save(name: "abcde")
//            if let model = MiddleModel.deserialize(from: dict) {
//                //            print(model)
//            }
//        }
        
        group.notify(queue: DispatchQueue.main) {
            print(snapArr)
            print("Both methods are completed.")
        }
    }
}


struct NewModel: SmartCodable {
    var new_a: String = ""
    var new_b: String = ""
    var new_c: String = ""
    var new_d: String = ""
    var new_e: String = ""
    var new_f: String = ""
}



struct OldModel: SmartCodable {
    var old_a: String = ""
    var old_b: String = ""
    var old_c: String = ""
    var old_d: String = ""
    var old_e: String = ""
    var old_f: String = ""
}



struct MiddleModel: SmartCodable {
    var middle_a: String = ""
    var middle_b: String = ""
    var middle_c: String = ""
    var middle_d: String = ""
    var middle_e: String = ""
    var middle_f: String = ""
}


