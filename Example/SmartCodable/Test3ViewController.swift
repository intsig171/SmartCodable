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

        let dict = ThreadSafeDictionary<String, [String]>()
        dict.setValue(["one11", "one22", "one33"], forKey: "one")
        dict.setValue(["two11", "two22", "two33"], forKey: "two")
        dict.setValue(["three11", "three22", "three33"], forKey: "three")
        
        // 等待一小会儿以确保异步操作完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print(dict.dictionary)
        }
        print("\n")
        dict.updateEach { key, value in
            value.append(key)
        }
        // 等待一小会儿以确保异步操作完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print(dict.dictionary)
        }
    }
    
    struct Model {
        var name: String = ""
        static func make(name: String) -> Self? {
            return Model(name: name)
        }
    }

}
