//
//  DecodingLogViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/9.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation


import SmartCodable


/** 日志等级 详细信息请查看 SmartConfig类
 * 通过配置SmartConfig.debugMode 设置日志登记
 */


/** 编码错误提示 详细信息请查看 resolveError(_ error: Error, className: String?) 方法
 ============= 💔 [SmartLog Error] 💔 =============
 错误类型: 找不到键的错误
 模型名称：DecodeErrorPrint
 属性信息：name
 错误原因: No value associated with key CodingKeys(stringValue: "name", intValue: nil) ("name").
 ==================================================
 
 ============= 💔 [SmartLog Error] 💔 =============
 错误类型: 值类型不匹配的错误
 模型名称：DecodeErrorPrint
 属性信息：a | 类型Bool
 错误原因: Expected to decode Bool but found a string/data instead.
 ==================================================
 
 ============= 💔 [SmartLog Error] 💔 =============
 错误类型: 找不到键的错误
 模型名称：DecodeErrorPrint
 属性信息：c
 错误原因: No value associated with key CodingKeys(stringValue: "c", intValue: nil) ("c").
 ==================================================

 */

class DecodingLogViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        SmartConfig.debugMode = .error
        
        guard let value = DecodeErrorPrint.deserialize(from: getDecodeErrorPrint()) else { return }
        print(value.a)
        print(value.name)
        print(value.c)
    }
}


extension DecodingLogViewController {
    func getDecodeErrorPrint() -> [String: Any] {
        let dict = [
            "a":"a",
            "b": 1,
            "c": NSNull()
        ] as [String : Any]
        
        return dict
    }
    
    struct DecodeErrorPrint: SmartCodable {

        // 验证无对应字段的情况
        var name: String = ""

        // 验证类型不匹配的情况
        var a: Bool = false

        // 验证null的情况
        var c: Bool = false
        init() { }
    }
}



