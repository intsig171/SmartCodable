//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint


/** 字典的值情况
 1. @Published 修饰的属性的解析。
 2. 继承关系！！！！
 *
 */


/**
 V4.1.12 发布公告
 1. 【新功能】支持Combine，允许@Published修饰的属性解析。
 2. 【新功能】支持@igonreKey修饰的属性在encode时，不出现在json中（屏蔽这个属性key）
 3. 【新功能】支持encode时候的options，同decode的options使用。
 4. 【优化】Data类型在decode和encode时，只能使用base64解析.
 */


class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let jsonString = """
[
{
    "enjoyCount": 1,
    "commentCount": 1,
},
{
    "enjoyCount": 2,
    "commentCount": 2,
},
{
    "enjoyCount": 2,
    "commentCount": 2,
}
]
    
"""
        guard let models = [RecommendModel].deserialize(from: jsonString) else {
            return
        }
        print(models)
        print("\n")
        
        let uniqueRecommends = Array(Set(models))
        print(uniqueRecommends)
    }
    
    struct RecommendModel: SmartCodable, Equatable, Hashable {

        /// 点赞数
        var enjoyCount: Int = 0
        /// 评论数
        var commentCount: Int = 0
        
        @IgnoredKey
        var priceText: NSAttributedString? // 价格富文本
        
        
        static func == (lhs: RecommendModel, rhs: RecommendModel) -> Bool {
            return true
        }
        
        // 手动实现 Hashable 协议
        func hash(into hasher: inout Hasher) {
            hasher.combine(enjoyCount)
            hasher.combine(commentCount)
        }
    }
    
}
