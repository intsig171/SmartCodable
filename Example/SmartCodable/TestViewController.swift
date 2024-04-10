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


class TestViewController: BaseViewController {

    var model: SmartModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        let dict1: [String: Any] = [
            "date": "2024-04-07",
            "date2": 1712491290,
            "url": "www.baidu.com",
            "color": "7DA5E3",
            "sub": [
                "subDate": 1712491290,
                "subColor": "7DA5E3",
            ]
        ]
        guard let model1 = SmartModel.deserialize(from: dict1) else { return }
        model = model1
        printStruct(model1)
        
        guard let dataValue = model1.toDictionary() else { return }
        BTPrint.print(dataValue)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.backgroundColor = model?.color?.peel
        if let url = model?.url {
            UIApplication.shared.open(url)
        }
    }
}




func printStruct<T>(_ value: T) {
    let mirror = Mirror(reflecting: value)
    var components = [String]()
    
    for child in mirror.children {
        if let label = child.label {
            components.append("\(label): \(child.value)")
        } else {
            components.append("\(child.value)")
        }
    }
    
    
    print(components.joined(separator: "\n"))
}

extension TestViewController {
    
    struct SmartModel: SmartCodable {
        var date1: Date?
        var date2: Date?
        var url: URL?
        
        var ignoreKey: String?
        var color: SmartColor?
        
        var sub: SmartSubModel?
        
        
        // case 1 【解析前】：解析忽略
        enum CodingKeys: CodingKey {
            case date1
            case date2
            case url
//            case ignoreKey
            case color
            case sub
        }
        
        // case 2 【解析中】： key的映射关系
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.date1 <--- ["date", "date1"],
                CodingKeys.date2 <--- "dict.dict.date"
            ]
        }
        
        // case 2 【解析中】： value的解析策略
        static func mappingForValue() -> [SmartValueTransformer]? {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            return [
                CodingKeys.url <--- SmartURLTransformer(prefix: "https://"),
                CodingKeys.date2 <--- SmartDateTransformer(),
                CodingKeys.date1 <--- SmartDateFormatTransformer(format)
            ]
        }
        
        // case 4 【解析后】： 进行自定义的数据处理
        func didFinishMapping() {
            
        }
    }
    
    struct SmartSubModel: SmartCodable {

        var subDate: Date?
        var subColor: SmartColor?
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            [
                CodingKeys.subDate <--- "date2"
            ]
        }
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            [
                CodingKeys.subDate <--- SmartDateTransformer(),
                CodingKeys.subColor <--- SmartHexColorTransformer()
            ]
        }
    }
}

