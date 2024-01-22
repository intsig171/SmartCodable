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


class TestViewController : BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let json = """
         {
             "total":null,
             "data":[
                 {
                                          "questionId":20,
                                          "pid":0,
                                          "content":"&lt;p&gt;说得好&lt;/p&gt;",
                                          "userId":9,
                                          "state":"OnShelf",
                                          "relation":null,
                                          "title":null,
                                          "siteId":null,
                                          "categoryId":null,
                                          "authorName":"18671714252",
                                          "authorAvatar":"https://sohugloba.oss-cn-beijing.aliyuncs.com/2023/11/24/5b3f0fee2d9d43a188c1dddd6fa90222.jpg",
                                          "followObj":false,
                                          "praiseObj":false,
                                          "collectObj":false,
                                          "praiseCount":0,
                                          "commentCount":0,
                                          "viewCount":0,
                                          "collectCount":0,
                                          "forwardCount":0,
                                          "createTime":"2023-11-21 17:10:48",
                                          "commentList":null
                 }
             ],
             "code":200,
             "msg":"查询成功"
         }
         """
        
        
        if let model = BXSBaseResultModel.deserialize(json: json) {
//            print(model.data.peel)
            
            let dict = model.toDictionary() ?? [:]
            print(dict)
            let dataArray = dict["data"] as? [Any] ?? []
            if let item = dataArray.first as? [String: Any] {
                if let relation = item["relation"], relation is NSNull {
                    print(relation)
                    print("relation == null")
                } else {
                    // relation 不为 null 的其他处理
                }
            }
        } else {
            print("error")
        }
        
        
        
        
    }
    
   
}

public struct BXSBaseResultModel :SmartCodable {
   
    public var total: SmartAny?
    public var code: Int?
    public var msg: String?
    public var data: SmartAny = .bool(false)
    
    public init() {}
}
