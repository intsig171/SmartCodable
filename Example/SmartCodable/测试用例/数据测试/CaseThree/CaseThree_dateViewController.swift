//
//  CaseThree_dateViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SmartCodable

class CaseThree_dateViewController: BaseCompatibilityViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func smart() {
        
    }
    
    
    func testDecoder() {
        let decoder = SmartJSONDecoder()
        
        // 5种情况，逐个测试。
//        let strategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
        
//        let strategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970
        
//        let strategy: JSONDecoder.DateDecodingStrategy = .millisecondsSince1970
        
//        let strategy: JSONDecoder.DateDecodingStrategy = .iso8601
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy年MM月dd号 hh点mm分"
//        let strategy: JSONDecoder.DateDecodingStrategy = .formatted(formatter)

        let strategy: JSONDecoder.DateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string")
        }


        
        decoder.dateDecodingStrategy = strategy
        let dict = getDictData(mode: .normal, strategy: strategy)
        
        if let model = try? decoder.decode(DateModel.self, from: dict) {
            print(model)
        }
    }
}



extension CaseThree_dateViewController {
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
        strategy: JSONDecoder.DateDecodingStrategy) -> [String: Any] {
            
            switch mode {
            case .keyless:
                return [:]
            case .null:
                return [
                    "aDate": NSNull(),
                    "bDate": NSNull(),
                ]
            case .typeMismatch:
                return [
                    "aDate": [],
                    "bDate": [ : ]
                ]
            case .normal:
                break
            }
            
            
            let currentDate = Date()
            
            switch strategy {
            case .deferredToDate:
                return [
                    "aDate": currentDate.timeIntervalSinceReferenceDate,
                    "bDate": currentDate.timeIntervalSinceReferenceDate,
                ]
                
            case .secondsSince1970:
                return [
                    "aDate": currentDate.timeIntervalSince1970,
                    "bDate": currentDate.timeIntervalSince1970,
                ]
            case .millisecondsSince1970:
                return [
                    "aDate": currentDate.timeIntervalSince1970*1000,
                    "bDate": currentDate.timeIntervalSince1970*1000,
                ]
            case .iso8601:
                return [
                    "aDate": "2024-03-01T12:00:00+00:00",
                    "bDate": "2024-03-01T12:00:00+00:00",
                ]
            case .formatted(_):
                return [
                    "aDate": "2024年03月01号 11点11分",
                    "bDate": "2024年03月01号 11点11分",
                ]
            case .custom(_):
                return [
                    "aDate": "01-03-2024",
                    "bDate": "01-03-2024",
                ]
            }
            
        }
}


extension CaseThree_dateViewController {
    struct DateModel: SmartCodable {
        var aDate: Date = Date()
        var bDate: Date?
    }
}
