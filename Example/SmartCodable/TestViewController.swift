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
    let jsonArrayString: String? = "{\"result\":{\"data\":[{\"name\":\"Bob\",\"id\":\"1\",\"height\":180},{\"name\":\"Lily\",\"id\":\"2\",\"height\":150},{\"name\":\"Lucy\",\"id\":\"3\",\"height\":160}]}}"
    
    let jsonString = "{\"data\":{\"result\":{\"id\":123456,\"arr1\":[1,2,3,4,5,6],\"arr2\":[\"a\",\"b\",\"c\",\"d\",\"e\"]}},\"code\":200}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smartTest()
        handyTest()
    }
}
extension TestViewController {
    
    
    func smartTest() {
        SmartConfig.debugMode = .verbose
        
        let data = jsonString.data(using: .utf8)

        guard let model = Family.deserialize(from: data, designatedPath: "data.result") else { return }
        print(model)
    }
    
    struct Family: SmartCodable {
        var id: Int?
        var arr1: [Int?]!
        var arr2: [String?]?
    }
}


extension TestViewController {
    
    
    func handyTest() {

        guard let model = Home.deserialize(from: jsonString, designatedPath: "data.result") else { return }
        print(model)
    }
    
    struct Home: HandyJSON {
        var id: Int?
        var arr1: [Int?]!
        var arr2: [String?]?
    }
}
