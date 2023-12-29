//
//  CaseThreeViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/11/22.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


class CaseThreeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode  = .none
        
        let dict = [
            "name": "小明"
        ]

        guard let model = CaseThreeModel.deserialize(dict: dict) else { return }
        print(model)


        let dict1 = [
            "nickName": "小丽"
            
        ]
        guard let model1 = CaseThreeModel.deserialize(dict: dict1) else { return }
        print(model1)


        let dict2 = [
            "realName": "小黄"
        ]
        guard let model2 = CaseThreeModel.deserialize(dict: dict2) else { return }
        print(model2)
        
        
        
        // 跨层级的情况
        let dict3 = [
            "userinfo": [
                "name": "小蛮"
            ]
        ]
        guard let model3 = CaseThreeModel.deserialize(dict: dict3) else { return }
        print(model3)
        
    }
}

struct CaseThreeModel: SmartCodable {
    init() { }
    
    // 对外的属性
    var name: String = ""
    var age: Int = 0
    
    
    // 内部解析
    private var nickName: String = ""
    private var realName: String = ""
    private var userinfo: [String: String] = [:]

    
    

    enum CodingKeys: CodingKey {
        case name
        case age
        case nickName
        case realName
        case userinfo
    }

    enum UserinfoCodingKeys: CodingKey {
        case name
    }
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let value = try? container.decodeIfPresent(String.self, forKey: .name) {
            self.name = value ?? ""
        } else if let value = try? container.decodeIfPresent(String.self, forKey: .nickName) {
            self.name = value ?? ""
        } else if let value = try? container.decodeIfPresent(String.self, forKey: .realName) {
            self.name = value ?? ""
        } else {
            self.name = ""
        }
        
        
        if let scoresContainer = try? container.nestedContainer(keyedBy: UserinfoCodingKeys.self, forKey: .userinfo) {
            if let value = try? scoresContainer.decodeIfPresent(String.self, forKey: .name) {
                self.name = value ?? ""
            }
        }
        
        
        self.age = try container.decode(Int.self, forKey: .age)
    }
}
