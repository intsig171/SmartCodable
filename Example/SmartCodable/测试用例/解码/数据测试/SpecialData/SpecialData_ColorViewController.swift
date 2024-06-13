//
//  SpecialData_ColorViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/5/22.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class SpecialData_ColorViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    
        let dict: [String: Any] = [
            "color2": NSNull(),
            "color3": "VVVVVV", // bad color hex
            "color4": "7DA5E3"
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        smartPrint(value: model)
        
        view.backgroundColor = model.color3.peel
    }
}


extension SpecialData_ColorViewController {
    struct Model: SmartCodable {
        var color1: SmartColor?
        var color2: SmartColor?
        var color3: SmartColor = .color(UIColor.yellow)
        var color4: SmartColor = .color(UIColor.red)
    }
}



