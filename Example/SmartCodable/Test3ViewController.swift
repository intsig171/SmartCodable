//
//  Test3ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/18.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON
import CleanJSON


/** 测试内容项
 1. 默认值的使用是否正常
 2. mappingForValue是否正常。
 3.
 */


import SmartCodable

class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict1: [String: Any] = [
            "code": "10000",
            "msg": "成功",
            "data": [
                "guideSvga": "guideSvga",
                "guideOnevga": "guideOnevga",
                "loadingSvga": "loadingSvga",
                "loadingSvgaBackgroundColor": "loadingSvgaBackgroundColor",
            ]
        ]
        
        guard let model = ResponseData<HomeListModel>.deserialize(from: dict1) else { return }
        print(model)
    }
    
    struct HomeListModel: SmartCodable {
        var guideSvga = ""
        var guideOnevga = ""
        var loadingSvga = ""
        var loadingSvgaBackgroundColor = ""
    }
    
    struct ResponseData<T>: SmartCodable where T: SmartCodable {
        var code = ""
        var msg = ""
        var data: T?
    }
}

