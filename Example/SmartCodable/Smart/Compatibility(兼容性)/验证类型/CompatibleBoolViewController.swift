//
//  CompatibleBoolViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable


/// 对Bool类型进行兼容，我们认为是Bool的Int/String类型的值
class CompatibleBoolViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                

        guard let adaptive = BoolAdaptive.deserialize(dict: getBoolAdaptiveData()) else { return }
        
        printValueType(key: "a", value: adaptive.a)
        printValueType(key: "b", value: adaptive.b)
        printValueType(key: "c", value: adaptive.c)
        printValueType(key: "d", value: adaptive.d)
        print("\n")

        printValueType(key: "e", value: adaptive.e)
        printValueType(key: "f", value: adaptive.f)
        printValueType(key: "g", value: adaptive.g)
        printValueType(key: "h", value: adaptive.h)
        printValueType(key: "i", value: adaptive.i)
        printValueType(key: "j", value: adaptive.j)
        print("\n")


        printValueType(key: "k", value: adaptive.k)
        printValueType(key: "l", value: adaptive.l)
        printValueType(key: "m", value: adaptive.m)
        printValueType(key: "n", value: adaptive.n)
        printValueType(key: "o", value: adaptive.o)
        printValueType(key: "p", value: adaptive.p)
        printValueType(key: "q", value: adaptive.q)
        printValueType(key: "r", value: adaptive.r)

        
        /**
         "属性：a 的类型是 Bool， 其值为 false"
         "属性：b 的类型是 Bool， 其值为 true"
         "属性：c 的类型是 Bool， 其值为 false"
         "属性：d 的类型是 Bool， 其值为 true"


         "属性：e 的类型是 Bool， 其值为 true"
         "属性：f 的类型是 Bool， 其值为 true"
         "属性：g 的类型是 Bool， 其值为 true"
         "属性：h 的类型是 Bool， 其值为 true"
         "属性：i 的类型是 Bool， 其值为 true"
         "属性：j 的类型是 Bool， 其值为 true"


         "属性：k 的类型是 Bool， 其值为 false"
         "属性：l 的类型是 Bool， 其值为 false"
         "属性：m 的类型是 Bool， 其值为 false"
         "属性：n 的类型是 Bool， 其值为 false"
         "属性：o 的类型是 Bool， 其值为 false"
         "属性：p 的类型是 Bool， 其值为 false"
         "属性：q 的类型是 Bool， 其值为 false"
         "属性：r 的类型是 Bool， 其值为 false"
         */
    }
}


extension CompatibleBoolViewController {
    func getBoolAdaptiveData() -> [String: Any] {
        let dict = [
            "a": 0,
            "b": 1,
            "c": "0",
            "d": "1",
            
            "e": "YES",
            "f": "Yes",
            "g": "yes",
            "h": "True",
            "i": "true",
            "j": "TRUE",
            
            "k": "NO",
            "l": "No",
            "m": "no",
            "n": "FALSE",
            "o": "False",
            "p": "false",
            "q": "ABC",
            "r": 234,
        ] as [String : Any]
        
        return dict
    }
}



struct BoolAdaptive: SmartCodable {
    init() { }
    
    var a: Bool?
    var b: Bool = false
    var c: Bool = false
    var d: Bool = false

    var e: Bool = false
    var f: Bool = false
    var g: Bool = false

    var h: Bool = false
    var i: Bool = false
    var j: Bool = false
    var k: Bool = false
    var l: Bool = false
    var m: Bool = false
    var n: Bool = false
    var o: Bool = false
    var p: Bool = false
    var q: Bool = false
    var r: Bool?
}



