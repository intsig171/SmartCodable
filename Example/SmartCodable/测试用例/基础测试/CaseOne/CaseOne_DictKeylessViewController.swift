//
//  CaseOne_KeylessViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable

class CaseOne_DictKeylessViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dict = keylssJson.toDictionary() else { return }

        let keylessArr: [Any] = [dict]
        
//        if let models = [CompatibleTypes].deserialize(array: keylessArr) as? [CompatibleTypes] {
//            print(models)
//        }
        
        if let models = [OptionalCompatibleTypes].deserialize(array: keylessArr) as? [OptionalCompatibleTypes] {
            print(models)
        }
        
    }

}
