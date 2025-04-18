//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()


        myFunction()
        
    }
    
    func myFunction() {
        print("Currently running \(#function)")
        
        #warning("Something's wrong")
    }
}
