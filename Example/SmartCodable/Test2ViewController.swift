//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON



class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dict: [String: Any] = [

            "type1": [],
            "type2": "3",
            
            "any1": NSNull(),
            "any2": "3",
            
            
            "dict1": [],
            "dict2": [
                "one": 1,
                "two": "2"
            ],
            
            "arr1": 1,
            "arr2": ["abc"],
            
            "color1": "666666",
            "color2": "000000"
        ]
        
        guard let model = Family.deserialize(from: dict) else { return }
        print(model)
        
//        print(UIColor.white)

    }

    
    
}


extension Test2ViewController {
    
    enum RealtionEnum: SmartAssociatedEnumerable {
        static var defaultCase: RealtionEnum = .one
        case one
        case two

    }
    
    enum FamilyType: String, SmartCaseDefaultable {
        static var defaultCase: FamilyType = .new
        
        case new = "1"
        case old = "2"
        case middle = "3"
    }
    
    /** 覆盖测试情况
     * [完成]枚举
     * [完成]SmartAny
     * [完成][String: SmartAny]
     * [完成][SmartAny]
     * [完成]SmartColor
     * URL
     */
    struct Family: SmartCodable {
        
//        var rela: RealtionEnum = .one
//        var rela1: RealtionEnum = .two
        
//        var type: FamilyType = .old
//        var type1: FamilyType = .old
//        var type2: FamilyType = .old

//        var any: SmartAny = .string("1")
//        var any1: SmartAny?
//        var any2: SmartAny = .string("3")
        
//        var dict: [String: SmartAny] = ["one": SmartAny.string("1")]
//        var dict1: [String: SmartAny] = ["two": SmartAny.string("2")]
//        var dict2: [String: SmartAny] = ["three": SmartAny.string("3")]

//        var arr : [SmartAny] = [SmartAny.number(1)]
//        var arr1 : [SmartAny] = [SmartAny.number(2)]
//        var arr2 : [SmartAny] = [SmartAny.number(3)]
        
//        var color: SmartColor = .color(.white)
//        var color1: SmartColor = .color(.black)
//        var color2: SmartColor = .color(.red)
        

//        var dict: SmartAny?
//        var color: SmartColor = .color(UIColor.red)
//        var url: URL?
    }
    

}
