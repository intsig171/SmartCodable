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

class Introduce_8ViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    
        let dict = [
            "number": "one",
//            "sex": "haha"
        ]
        
        guard let model = CompatibleEnum.deserialize(from: dict) else { return }
        print(model)

        // 如果进入兼容逻辑，json值将被修改，无法恢复。
        guard let transformDict = model.toDictionary() else { return }
        print(transformDict)
        
        /**
         ["enum1": a]
         */
    }
}


extension Introduce_8ViewController {
    
    struct CompatibleEnum: SmartCodable {

        init() { }
        var number: NumberType?
        var sex: Sex = .man
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.sex <--- RelationEnumTranformer()
            ]
        }
    }
    
    enum NumberType: String, SmartCaseDefaultable {
        static var defaultCase: NumberType = .one
        
        case one
        case two
        case three
    }
    
    enum Sex: SmartAssociatedEnumerable {
        static var defaultCase: Sex = .women
        
        case man
        case women
        case other(String)
    }
}


extension Introduce_8ViewController {
    struct RelationEnumTranformer: ValueTransformable {
        
        
        typealias Object = Sex
        typealias JSON = String
        
        func transformFromJSON(_ value: Any?) -> Sex? {
            guard let temp = value as? String else { return .man }

            switch temp {
            case "man":
                return .man
            case "women":
                return .women
            default:
                return .other(temp)
            }
        }
    }
}
