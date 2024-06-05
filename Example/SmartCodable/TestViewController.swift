//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint

import SmartCodable

class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [:]
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()
        
        queue.async(group: group) {
            if let model = NewModel.deserialize(from: dict) {
                print(model)
            }
        }
        
        queue.async(group: group) {
            if let model = OldModel.deserialize(from: dict) {
                print(model)
            }
        }
        
        queue.async(group: group) {
            if let model = MiddleModel.deserialize(from: dict) {
                print(model)
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("Both methods are completed.")
        }
    }
}


struct NewModel: SmartCodable {
    var new_a: String = ""
    var new_bbbbb: String = ""
    var new_c: String = ""
    var new_d: String = ""
    var new_e: String = ""
    var new_f: String = ""
}



struct OldModel: SmartCodable {
    var old_a: String = ""
    var old_bbbbb: String = ""
    var old_c: String = ""
    var old_d: String = ""
    var old_e: String = ""
    var old_f: String = ""
}



struct MiddleModel: SmartCodable {
    var middle_a: String = ""
    var middle_b: String = ""
    var middle_c: String = ""
    var middle_d: String = ""
    var middle_e: String = ""
    var middle_f: String = ""
}


