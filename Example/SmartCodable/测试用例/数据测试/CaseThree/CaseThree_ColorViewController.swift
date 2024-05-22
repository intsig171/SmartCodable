//
//  CaseThree_ColorViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/5/22.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class CaseThree_ColorViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    
        let dict: [String: Any] = [
//            "color1": "7DA5E3",
            "color2": "7DA5E3",
//            "color3": "7DA5E3",
//            "color4": NSNull()
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        smartPrint(value: model)
        
        view.backgroundColor = model.color4.peel
    }
}


extension CaseThree_ColorViewController {
    struct Model: SmartCodable {
//        var color1: SmartColor?
//        var color2: SmartColor?
//        var color3: SmartColor = .color(UIColor.white)
        var color4: SmartColor = .color(UIColor.red)
    }
}



