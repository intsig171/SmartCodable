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


/** todo
 1. 【done】issue，数组model属性（或非model的数组），遇到json str。
 2. 【done】其他类型新增解析策略
 3. 【done】验证解析失败使用初始值的场景。并看看value的自定义解析策略。
 4. 【done】SmartAny的解析失败的验证。
 5. 关联值的解析支持。
 
 */


class TestViewController: BaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = """
{
  "typeid" : 33,
  "data" : {
    "boxnum" : 0,
    "boxname" : "",
    "queue" : 0,
    "userinfo" : {
      "vip" : 6,
      "uid" : 101080,
      "age" : 21,
      "sex" : 1,
      "self_cid" : 0,
      "viplevel" : 0,
      "color" : "#209948",
      "avatar" : "http",
      "sid" : "37",
      "medal" : "http",
      "vipicon" : "http",
      "city" : null,
      "teacher" : 1,
      "nickname" : "u101080",
      "online" : 0,
      "name" : "u101080",
      "vipuid" : 0
    },
    "gift" : {
      "diamond" : 520,
      "pic" : "http",
      "title" : "魔法戒指"
    },
    "giftnum" : 1,
    "self" : 0,
    "giftUsername" : "哦公民♔⁎͜⁛",
    "chatname" : "花开富贵HF官方",
    "cid" : 23827
  },
  "cid" : 0,
  "type" : 60
}
"""
        
        
        
        if let jsonObject = TOReceiveSocketItem.deserialize(from: json) {
            print(jsonObject)
        }
    }
}
public class TOReceiveSocketItem: SmartCodable {
    required public init() {}
    /// 接收socket消息类型
    public var typeid: Int = 0
    public var error: Int?
    /// 错误信息
    public var error_msg: String?
    public var cid: Int = 0
    public var position: Int = 0
    public var data: [TOChatroomWheatListItem]?
    ///  1 显示    0不显示
    public var invite : Int?
    public var wheatUid: [String: Int]?
    public var uids: [Int]?
    /// 老板
    public var uid: Int = 0
    /// 老板状态：0入座 -1离开
    public var state: Int = -2
    /// 老板消息
    public var msg: String?
    public var type: Int?
    ///  你画我猜
    public var isAllPrepared: Int? //所有人1.已准备0未准备
    public var cd: Int? //剩余CD时间
    public var currSignal: Int? //所处阶段
    public var stage : Int?
    public var desc : String?
}

public class TOChatroomWheatListItem: SmartCodable {
    
    public var boxname: String = ""
    public var error_msg: String = ""

    public var boxnum: Int = 0
    public var queue: Int = 0
    public var cid: Int = 0
    required public init() {}

}
