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
            "cgFloat": 20.0
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
    }

    
    struct Model: SmartCodable {
        var cgFloat: CGFloat = 0.0

        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.cgFloat <--- CGFloatTransformer()
            ]
        }
    }
}


extension Test2ViewController {
    struct CGFloatTransformer: ValueTransformable {
        func transformFromJSON(_ value: Any?) -> CGFloat? {
            if let temp = value as? CGFloat {
                print(100 + temp)

                return 100 + temp
                
                
            }
            return nil
        }
        
        func transformToJSON(_ value: CGFloat?) -> CGFloat? {
            return value
        }
        
        typealias Object = CGFloat
        typealias JSON = CGFloat
    }

}
