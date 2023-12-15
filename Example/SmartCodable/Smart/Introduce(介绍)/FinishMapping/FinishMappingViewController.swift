//
//  FinishMappingViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation


import SmartCodable


/** didFinishMap的用法
 * 含义
 * - 1. 当前类，结束decode之后的回调
 *
 * 作用
 * - 1. 提供类在decode之后，进一步对值进行处理的能力
 *
 * 场景覆盖：
 * - 1. 单容器 （解析成功 && 解析失败）
 * - 2. 单可选容器 （解析成功 && 解析失败）
 * - 3. 嵌套容器 （解析成功 && 解析失败）
 * - 4. 嵌套可选容器 （解析成功 && 解析失败）
 */

class FinishMappingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
        
        
        // 1⃣️ 单容器验证
        singleDict()
        
        compositeDict()
        
        
        singleArray()

        
        
        test()
    }

}


extension FinishMappingViewController {
    
    func test() {
        let json = """

        [
            {
                "title":"请假申请",
                "sections":[
                    {
                        "title":"123",
                        "items":[
                            {
                                "title":"请假类型",
                            }
                        ]
                    }
                ]
            }
            
        ]

        """
        

        guard let arr = [ListFinishTest].deserialize(json: json) else { return }
        print(arr)
    }
    
    
    struct ListFinishTest: SmartCodable {
        var title: String = ""
        
        
        var sections: [ModelOne] = []
        
        mutating func didFinishMapping() {
            title = "我是\(title)"
        }
    }

    struct ModelOne: SmartCodable {
        var title: String = ""
        var items: [ModelTwo] = []
        
        
        mutating func didFinishMapping() {
            title = "ModelOne: 我是\(title)"
        }
    }

    struct ModelTwo: SmartCodable {
        var title: String = ""
        
        mutating func didFinishMapping() {
            title = "ModelTwo: 我是\(title)"
        }
    }


}


