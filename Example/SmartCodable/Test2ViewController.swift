//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let string = "{\"id\":23,\"position\":3,\"pushType\":24,\"content\":\"低调对对对对对对低调\",\"linkWords\":\"\",\"link\":\"\",\"extra\":\"{\\\"userInfo\\\":{\\\"uid\\\":12,\\\"sex\\\":1,\\\"avatar\\\":\\\"xxxxx.jpg\\\",\\\"age\\\":43,\\\"nickname\\\":\\\"阿萨德的的的的的\\\",\\\"height\\\":\\\"166\\\",\\\"realAuth\\\":0}}\"}"
  

//        if let data = string.data(using: .utf8) {
//            do {
//                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    print("JSON is valid: \(jsonObject)")
//                    
//                    if let extraString = jsonObject["extra"] as? String,
//                       let extraData = extraString.data(using: .utf8),
//                       let extraObject = try JSONSerialization.jsonObject(with: extraData, options: []) as? [String: Any] {
//                        print("Extra JSON is valid: \(extraObject)")
//                    }
//                }
//            } catch {
//                print("JSON is invalid: \(error.localizedDescription)")
//            }
//        }
        
        let dict = string.toDictionary() ?? [:]
        
        print(dict)
        
//        if let model = dict.decode(type: SmartOtherModel.self) {
//            smartPrint(value: model.extra.userInfo)
//        }
//        BTPrint.print(dict)
//        
        if let customElem = SmartOtherModel.deserialize(from: string) {
            smartPrint(value: customElem.extra.userInfo)
        }
    }
   
}

public enum SmartOtherType: Int, SmartCaseDefaultable {
    case one = 22
    case two
    case three
    case four
}

public class SmartOtherModel: SmartCodable {
//    var id: Int64 = 0
//    var pushType: SmartOtherType = .one
//    var position: Int = 0
//    var content: String = ""
//    var linkWords: String = ""
//    var link: String = ""
//    var lock: Int = 0
    var extra: SmartOtherExtraModel = .init()
    required public init() { }
}

public class SmartOtherExtraModel: SmartCodable {
    var userInfo: SmartOtherUserModel = .init()
//    var moments: SmartOtherContentModel = .init()
//    var comment: SmartOtherInputModel = .init()
//    var reply: SmartOtherInputModel = .init()
    required public init() { }
}

public class SmartOtherUserModel: SmartCodable {
//    var uid: Int64 = 0
    var sex: Int = 0
//    var avatar: String = ""
//    var age: Int = 0
//    var nickname: String = ""
//    var height: String = ""
//    var realAuth: Bool = false
    required public init() { }
}

public class SmartOtherContentModel: SmartCodable {
    var id: Int64 = 0
    var type: Int = 0
    var content: String = ""
    required public init() { }
}

public class SmartOtherInputModel: SmartCodable {
    var content: String = ""
    required public init() { }
}


