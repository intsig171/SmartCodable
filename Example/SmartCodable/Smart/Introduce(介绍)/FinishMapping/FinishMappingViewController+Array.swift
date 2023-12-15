//
//  FinishMappingViewController+Array.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/12/15.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

extension FinishMappingViewController {
    func singleArray() {
        
        let arr = [
            ["name": "xiaoming"],
            ["name": "huahua"]
        ]
        
        
        guard let models = [SingleModel].deserialize(array: arr) as? [SingleModel] else { return }
        print(models)
    }
    
    
    
    struct SingleModel: SmartCodable {
        var name: String = ""
        mutating func didFinishMapping() {
            name = "SingleModel：修改了\(name)"
        }
    }
}

