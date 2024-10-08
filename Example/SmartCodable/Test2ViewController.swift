//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint
import Combine

class Test2ViewController: BaseViewController {
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = [
            "name": 1.22222
        ]
        let model = Model.deserialize(from: dict)
        print(model)

    }
    
    struct Model: SmartCodable {
        var name: String = ""
        
        
    }
}
