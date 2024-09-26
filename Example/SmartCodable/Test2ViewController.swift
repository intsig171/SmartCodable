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
        
        let model = Model()
        
        let json = model.toDictionary()
        
        print(json)

    }
    
    struct Model: SmartCodable {
        var name: String = "Mccc"
        
        @IgnoredKey(supportEncode: false)
        var ignore1: String = "忽略的key1"
        
        @IgnoredKey(supportEncode: true)
        var ignore2: String = "忽略的key2"
        
    }
}
