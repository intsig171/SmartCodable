//
//  Container_ArrayTypeMismatchViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class Container_ArrayTypeMismatchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        guard let dict = typeMissmatchJson.toDictionary() else { return }
        
        
        let typeMismatchArr: [Any] = [dict]
        
        if let models = [CompatibleTypes].deserialize(from: typeMismatchArr) as? [CompatibleTypes] {
            print(models)
        }
        
        if let models = [OptionalCompatibleTypes].deserialize(from: typeMismatchArr) as? [OptionalCompatibleTypes] {
            print(models)
        }
    }
}


