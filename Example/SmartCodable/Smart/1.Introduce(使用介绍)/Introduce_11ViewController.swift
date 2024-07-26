//
//  Introduce_11ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/6/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class Introduce_11ViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        var dest = Model(name: "xiaoming", hobby: "football")
        let src = Model(name: "dahuang", hobby: "sleep")

        print(dest)
        SmartUpdater.update(&dest, from: src, keyPath: \.name)
        
        print(dest)
        
        SmartUpdater.update(&dest, from: src, keyPaths: (\.name, \.hobby))
        
        print(dest)
    }
}


extension Introduce_11ViewController {
    
    struct Model: SmartCodable {
        var name: String = ""
        var hobby: String?
    }
}



