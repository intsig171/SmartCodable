//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON



class Test3ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       let dict = [
        "sex": "haha"
       ]

        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
    }
}

extension Test3ViewController {
    struct Model: SmartCodable {
        var sex: Sex = .man
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.sex <--- RelationEnumTranformer()
            ]
        }
    }
    
    enum Sex: SmartAssociatedEnumerable {
        case man
        case women
        case other(String)
    }
}

extension Test3ViewController {
    struct RelationEnumTranformer: ValueTransformable {
        
        typealias Object = Test3ViewController.Sex
        typealias JSON = String
        
        func transformFromJSON(_ value: Any?) -> Test3ViewController.Sex? {
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
