//
//  Strength_6ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/14.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

/** 枚举映射失败的情况
 * codable是自动将数据映射成枚举。
 * 通过SmartCaseDefaultable协议，兼容映射失败，返回一个默认值。
 */

class Strength_6ViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    
        let dict = [
            "enumTest": ""
        ]
        
        guard let model = CompatibleEnum.deserialize(dict: dict) else { return }
        print(model.enum1)
        print(model.enum2)

        // 如果进入兼容逻辑，json值将被修改，无法恢复。
        guard let transformDict = model.toDictionary() else { return }
        print(transformDict)
        
        /**
         ["enum1": a]
         */
    }
}


extension Strength_6ViewController {
    
    struct CompatibleEnum: SmartCodable {

        init() { }
        var enum1: TestEnum = .a
        var enum2: TestEnum?

        enum TestEnum: String, SmartCaseDefaultable {
            static var defaultCase: TestEnum = .a

            case a
            case b
            case hello = "c"
        }
    }

}





