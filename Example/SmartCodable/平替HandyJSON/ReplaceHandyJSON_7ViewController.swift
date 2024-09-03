//
//  ReplaceHandyJSON_7ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/9/3.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable

class ReplaceHandyJSON_7ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = readPlistData() else { return }
        
        if let model = Model.deserializePlist(from: data) {
            smartPrint(value: model)
        }

    }
    
    func readPlistData() -> Data? {
        // 获取plist文件的路径
        if let path = Bundle.main.path(forResource: "SpecialData_data", ofType: "plist") {
            // 将plist文件的内容加载到Data对象中
            if let data = FileManager.default.contents(atPath: path) {
                return data
            } else {
                print("无法读取plist文件内容")
            }
        } else {
            print("找不到plist文件")
        }
        return nil
    }
    
    struct Model: SmartCodable {
        var name: String?
        var age: Int?
    }
}
