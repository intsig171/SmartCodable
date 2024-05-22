//
//  CaseThree_DictViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class CaseThree_SmartAnyViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [

            "single_b": NSNull(),
            "single_c": ["abc": "Test"],
            "single_d": 123,
            
            "single_f": NSNull(),
            "single_g": ["abc": "Test"],
            "single_h": 123,
            
            
            "dict_b": NSNull(),
            "dict_c": 123,
            "dict_d": ["abc": 123],
            
            "dict_f": NSNull(),
            "dict_g": 123,
            "dict_h": ["abc": true],
            
            
            "arr_b": NSNull(),
            "arr_c": 123,
            "arr_d": [123],
            
            "arr_f": NSNull(),
            "arr_g": 123,
            "arr_h": ["abc"],
            
            "complex": [
                "a": [
                    "a": true,
                    "b": "mccc",
                    "c": 1.1
                ]
            ]
        ]
  
//        if let model = dict.decode(type: DictModel.self) {
//            print(model)
//        }
        
        if let model = DictModel.deserialize(from: dict) {
            smartPrint(value: model)
            
            print(model.complex)
        }
    }
}


extension CaseThree_SmartAnyViewController {
    struct DictModel: SmartCodable {
        
        var complex: [String: SmartAny] = [:]
        
//        var single_a: SmartAny?
//        var single_b: SmartAny?
//        var single_c: SmartAny?
//        var single_d: SmartAny?
//
//        var single_e: SmartAny = .string("single_e")
//        var single_f: SmartAny = .string("single_f")
//        var single_g: SmartAny = .string("single_g")
//        var single_h: SmartAny = .string("single_h")
//
//        
//        var dict_a: [String: SmartAny]?
//        var dict_b: [String: SmartAny]?
//        var dict_c: [String: SmartAny]?
//        var dict_d: [String: SmartAny]?
//        
//        var dict_e: [String: SmartAny] = [:]
//        var dict_f: [String: SmartAny] = [:]
//        var dict_g: [String: SmartAny] = [:]
//        var dict_h: [String: SmartAny] = [:]
//        
//        var arr_a: [SmartAny]?
//        var arr_b: [SmartAny]?
//        var arr_c: [SmartAny]?
//        var arr_d: [SmartAny]?
//
//        var arr_e: [SmartAny] = []
//        var arr_f: [SmartAny] = []
//        var arr_g: [SmartAny] = []
//        var arr_h: [SmartAny] = []
    }
}
