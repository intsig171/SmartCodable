//
//  CaseOne_DateViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/5/21.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class CaseOne_DateViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        let dict: [String: Any] = [
//            "a": "123",
            "b": "123.1",
            "c": 12.3,
            "d": NSNull(),
        ]
        
        guard let feed = DateModel.deserialize(from: dict) else { return }
//        print(feed)
        smartPrint(value: feed)
        /**
         "CompatibleInt的属性打印信息："
         "属性：int 的类型是 Int， 其值为 123"
         "属性：int1 的类型是 Optional<Int>， 其值为 nil"
         "属性：int2 的类型是 Optional<Int>， 其值为 nil"
         "属性：int3 的类型是 Optional<Int>， 其值为 nil"
         "属性：int4 的类型是 Optional<Int>， 其值为 nil"
         "属性：int5 的类型是 Optional<Int>， 其值为 nil"
         */
    }

}
extension CaseOne_DateViewController {
    struct DateModel: SmartCodable {
        var a: Date?
        var b: Date?
        var c: Date?
        var d: Date?
        
        
        var e: Date?
        var f: Date?
        var j: Date?
        var h: Date?
        
        init() { }
    }
}


