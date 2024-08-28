//
//  Container_ArrayNullViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class Container_ArrayNullViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        guard let dict = nullJson.toDictionary() else { return }
        
        
        let nullArr: [Any] = [dict]
        
        if let models = [CompatibleTypes].deserialize(from: nullArr) {
            smartPrint(value: models.first)
        }
        
        if let models = [OptionalCompatibleTypes].deserialize(from: nullArr) {
            smartPrint(value: models.first)
        }
    }

}
