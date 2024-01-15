//
//  DecodeErrorPrintViewController.swift
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
 * ======== [SmartLog Error] ========
 * 错误类型: '值类型不匹配的错误'
 * 字段信息：（类/结构体名）DecodeErrorPrint （字段类型）Bool （字段名称）a
 * 字段路径：[CodingKeys(stringValue: "a", intValue: nil)]
 * 错误原因: Expected to decode Bool but found a string/data instead.
 ===================================
 */

class DecodeErrorPrintViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        SmartConfig.debugMode = .debug
        let value1 = DecodeErrorPrint.deserialize(dict: nil) 

        guard let value = DecodeErrorPrint.deserialize(dict: getDecodeErrorPrint()) else { return }
        print(value.a)
        print(value.name)
        print(value.c)
    }
}


extension DecodeErrorPrintViewController {
    func getDecodeErrorPrint() -> [String: Any] {
        let dict = [
            "a":"a",
            "b": 1,
            "c": NSNull()
        ] as [String : Any]
        
        return dict
    }
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
