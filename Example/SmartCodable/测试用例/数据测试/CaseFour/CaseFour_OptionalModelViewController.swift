//
//  CaseFour_OptionalModelViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable

class CaseFour_OptionalModelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "model": [
                "name": "Mccc1"
            ],
            "optionalModel": [
                "name": "Mccc2"
            ],
            "classModel": [
                "name": "Mccc3"
            ],
            "optionalClassModel": [
                "name": "Mccc4"
            ],
        ]
        
        if let model = BigModel.deserialize(dict: dict) {
            print(model.classModel.name ?? "")
            print(model.optionalClassModel?.name ?? "")

            smartPrint(value: model)
        }
    }
}

extension CaseFour_OptionalModelViewController {
    
    struct BigModel: SmartCodable {
        var model = Model()
        var optionalModel: Model?
        
        var classModel = ClassModel()
        var optionalClassModel: ClassModel?
    }
    
    struct Model: SmartCodable {
        var name: String?
    }
    
    class ClassModel: SmartCodable {
        var name: String?
        
        required init() { }
    }
}
