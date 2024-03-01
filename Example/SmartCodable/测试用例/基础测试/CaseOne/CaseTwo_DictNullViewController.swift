//
//  CaseTwo_DictNullViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class CaseTwo_DictNullViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        guard let dict = nullJson.toDictionary() else { return }
        
        
        let nullArr: [Any] = [dict]
        
//        if let models = [CompatibleTypes].deserialize(array: nullArr) as? [CompatibleTypes] {
//            print(models)
//        }
        
        if let models = [OptionalCompatibleTypes].deserialize(array: nullArr) as? [OptionalCompatibleTypes] {
            print(models)
        }
    }

}
