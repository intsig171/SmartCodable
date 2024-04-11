//
//  CustomDecodingValueViewContriller.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable


/// 自定义Value的解析策略
class CustomDecodingValueViewContriller: BaseViewController {

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
        print(model1)
        
        print("\n")
        
        guard let dataValue = model1.toDictionary() else { return }
        print(dataValue)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.backgroundColor = model?.color?.peel
//        if let url = model?.url {
//            UIApplication.shared.open(url)
//        }
    }
}


extension CustomDecodingValueViewContriller {
    
    struct SmartModel: SmartCodable {
        var date1: Date?
        var date2: Date?
        var url: URL?
        
        var ignoreKey: String?
        var color: SmartColor?
        
        var sub: SmartSubModel?
        

        // value的解析策略
        static func mappingForValue() -> [SmartValueTransformer]? {
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            return [
                CodingKeys.url <--- SmartURLTransformer(prefix: "https://"),
                CodingKeys.date2 <--- SmartDateTransformer(),
                CodingKeys.date1 <--- SmartDateFormatTransformer(format)
            ]
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


