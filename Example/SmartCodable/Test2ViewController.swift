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



class Test2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let json = """
        {
            "printer_temp_tab": [
                {
                    "detail_list": [
                        {
                            "name": "实线纸",
                            "original": "https://ss-cdn.camscanner.com/10000_778773f1a68a40f666a95e9e4d2532e5.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_778773f1a68a40f666a95e9e4d2532e5.jpg"
                        },
                    ],
                    "icon_url": "https://ss-cdn.camscanner.com/10000_43a7e569bb204db279e9079086591251.png",
                    "title": "书写纸",
                    "type": 1
                },
            ]
        }
        """
        guard let model =  CEPrinterTemplateTab.deserialize(from: json) else { return }
        printStruct(model)
        print("\n")
        
        let printer_temp_tab = model.printer_temp_tab ?? []
    
        
        let listModel = [CEPrinterTemplateTotal].deserialize(from: printer_temp_tab)
        print(listModel as Any)
        print("\n")

        
        let firstDict = printer_temp_tab.first ?? [:]
        let firstModel = CEPrinterTemplateTotal.deserialize(from: firstDict)
        print(firstModel as Any)
         
        
        print("\n")
        
//        let dict = model.toDictionary()
//        print(dict)
    }

}

struct CEPrinterTemplateTab: SmartCodable {
    var printer_temp_tab: [[String: SmartAny]]?
}
struct CEPrinterTemplateTotal: SmartCodable {
    /// 类型名称
    var title: String?
    /// 类型图片
    var icon_url: String?
    /// 打印类型列表数据
    var detail_list: [CEPrinterTemplateItem] = []

    mutating func didFinishMapping() {
        for index in detail_list.indices {
            detail_list[index].typeName = title
        }
    }
}

struct CEPrinterTemplateItem: SmartCodable {
    /// 打印类型名称
    var name: String?
    /// 原图
    var original: String?
    /// 缩略图
    var thumb: String?
    /// 类型名称
    var typeName: String?
}



