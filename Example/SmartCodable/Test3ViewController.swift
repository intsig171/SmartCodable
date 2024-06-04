//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON



class Test3ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if var temp = Model.make(name: "Mccc") {
            temp.name = "abc"
            print(temp)
        }
    }
    
    struct Model {
        var name: String = ""
        static func make(name: String) -> Self? {
            return Model(name: name)
        }
    }

}
