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

        let json = "{\n  \"success\" : true,\n  \"data\" : [\n    {\n      \"rule\" : {\n        \"url\" : \"\",\n        \"title\" : \"Mother\'s Day Sale\",\n        \"type\" : 2,\n        \"param\" : {\n\n        }\n      },\n      \"title\" : \"Mother\'s Day Sale\"\n    },\n    {\n      \"rule\" : {\n        \"url\" : \"\",\n        \"title\" : \"Mother\'s Day Gift Ideas\",\n        \"type\" : 2,\n        \"param\" : {\n          \"categoryId\" : 5964\n        }\n      },\n      \"title\" : \"Mother\'s Day Gift Ideas\"\n    },\n    {\n      \"rule\" : {\n        \"url\" : \"app:\\/\\/category\\/main\",\n        \"title\" : \"SS24 Collection\",\n        \"type\" : 1,\n        \"param\" : {\n          \"categoryId\" : 11387\n        }\n      },\n      \"title\" : \"SS24 Collection\"\n    },\n    {\n      \"rule\" : {\n        \"url\" : \"app:\\/\\/category\\/main\",\n        \"title\" : \"Washable  Pajama\",\n        \"type\" : 1,\n        \"param\" : {\n          \"categoryId\" : 2331\n        }\n      },\n      \"title\" : \"Washable  Pajama\"\n    },\n    {\n      \"rule\" : {\n        \"url\" : \"\",\n        \"title\" : \"Up To 50% OFF\",\n        \"type\" : 2,\n        \"param\" : {\n          \"categoryId\" : 3542\n        }\n      },\n      \"title\" : \"Up To 50% OFF\"\n    },\n    {\n      \"rule\" : {\n        \"url\" : \"app:\\/\\/category\\/main\",\n        \"title\" : \"Best Sellers\",\n        \"type\" : 1,\n        \"param\" : {\n          \"categoryId\" : 9523\n        }\n      },\n      \"title\" : \"Best Sellers\"\n    }\n  ],\n  \"header\" : {\n    \"trace-id\" : \"ac501f1bb3f1196dd9ae6332652a0078\"\n  }\n}"
        
        guard let model = LSSearchRecommendModel.deserialize(from: json) else { return }
        smartPrint(value: model)

    }


}
class LSBaseModel: NSObject, Codable, SmartCodable {
    required override init() {
        super.init()
    }
    

}


protocol BaseProtocol { }

struct LSSearchRecommendModel: SmartCodable, BaseProtocol {
    var data: [ApolloSearchRecommendResponse]?
    var errCode, errMsg: String?
    var errMsgArgs: [String]?
    var success: Bool?
}

/// ApolloSearchRecommendResponse
// MARK: - ApolloSearchRecommendResponse
class ApolloSearchRecommendResponse: LSBaseModel {
    var param: MapObject?
    var title: String = ""
    var url: String?
    var rule: LSSearchMenuResHighlightsRule?
}
class MapObject: LSBaseModel {
    var key: [String: Any?]?
}
// MARK: - LSSearchMenuResHighlightsDataParam
class LSSearchMenuResHighlightsRule: LSBaseModel {
    
    /// key
    var key = ""
    /// 为 1 时，url字段为IOS路由 2 url字段为H5链接
    var type: Int = 1
    /// 链接
    var url = ""
    /// 标题
    var title = ""
    /// 数据
    var param: LSSearchMenuResHighlightsDataParam?
}
class LSSearchMenuResHighlightsDataParam: LSBaseModel {
    /// key
    var categoryId: Int?
}
