//
//  CaseThree_dataViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable

class CaseThree_dataViewController: BaseCompatibilityViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        test()
    }

    func getStrategy() -> JSONDecoder.DataDecodingStrategy {
        //        let strategy: JSONDecoder.DataDecodingStrategy = .base64
        
        let strategy: JSONDecoder.DataDecodingStrategy = .custom({ decoder -> Data in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            guard let data = string.data(using: .utf8) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "无法转换为Data类型")
            }
            return data
        })
        return strategy
    }
    
    func test() {
        let strategy = getStrategy()
        let dict = getDictData(mode: .normal, strategy: strategy)
        
        if let model = DataModel.deserialize(dict: dict, options: [.dataStrategy(strategy)]) {
            print(model)
            print(model.aData.toString() ?? "")
        }
    }
}


extension CaseThree_dataViewController {
    enum Mode {
        /// 缺少键
        case keyless
        /// 值为null
        case null
        /// 值类型错误
        case typeMismatch
        /// 正常数据
        case normal
    }
    
    
    func getDictData(
        mode: Mode,
        strategy: JSONDecoder.DataDecodingStrategy) -> [String: Any] {
            switch mode {
            case .keyless:
                return [:]
            case .null:
                return [
                    "aData": NSNull(),
                    "bData": NSNull(),
                ]
            case .typeMismatch:
                return [
                    "aData": [],
                    "bData": [ : ]
                ]
            case .normal:
                break
            }
            
            
           
            
            switch strategy {
                // 由于 JSON 标准本身不支持直接的二进制数据表示，我们通常不会在实践中看到 deferredToData 的直接应用。
            case .deferredToData:
                return [
                    :
                ]
                
            case .base64:
                return [
                    "aData": "aHR0cHM6Ly93d3cucWl4aW4uY29t",
                    "bData": "aHR0cHM6Ly93d3cucWl4aW4uY29t",
                ]
            case .custom(_):
                return [
                    "aData": "Hello, world!",
                    "bData": "Hello, world!",
                ]
            }
            
        }
}



extension CaseThree_dataViewController {
    struct DataModel: SmartCodable {
        var aData: Data = Data()
        var bData: Data?
    }
}
