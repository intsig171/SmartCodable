//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON



// todo 为什么
class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let json = """

        {\"msg\":\"操作成功\",\"code\":200,\"data\":{\"commonUse\": [{\"resId\":16,\"resName\":\"转正申请\",\"parentId\":3,\"resUrl\":null,\"picUrl\":\"/upload/app/staff.png\",\"isDefault\":2,\"children\":null}]}}

        """
        let value =  (SmartResponseData<[String:SmartAny]>).deserialize(from: json)

        print("\(value)")
    }

}


struct SmartResponseData<T:SmartCodable>:SmartCodable{
    var code: Int = 0
    var msg:String?
    var data: T?
}
struct TodoFatherModel: SmartCodable {
    var commonUse: [TodoModel] = []
}

struct TodoModel: SmartCodable {
    var resId: Int = 0
    var resName: String = ""
}


