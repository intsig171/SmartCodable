//
//  Container_ArrayTypeMismatchViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class Container_ArrayTypeMismatchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        guard let dict = typeMissmatchJson.toDictionary() else { return }
        
        
        let typeMismatchArr: [Any] = [dict]
        
        if let models = [CompatibleTypes].deserialize(from: typeMismatchArr) {
            smartPrint(value: models.first)
        }
        
        if let models = [OptionalCompatibleTypes].deserialize(from: typeMismatchArr) {
            smartPrint(value: models.first)
        }
    }
}


