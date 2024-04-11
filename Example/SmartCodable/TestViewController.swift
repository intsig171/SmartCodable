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

    override func viewDidLoad() {
        super.viewDidLoad()

        let dict1: [String: Any] = [
            "date": "2024-04-07",
            "date1": 1712491290,
            "date2": "2015-03-03T02:36:44"
        ]

        guard let model = Model.deserialize(from: dict1) else { return }
        print(model)
                
        
    }
}



extension TestViewController {
    
    struct Model: SmartCodable {
        var date: Date?
        var date1: Date?
        var date2: Date?
        
        static func mappingForValue() -> [SmartValueTransformer]? {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return [
                CodingKeys.date <--- SmartDateTransformer(),
                CodingKeys.date1 <--- SmartDateFormatTransformer(df),
                CodingKeys.date2 <--- ISO8601DateTransformer()
            ]
        }
    }
}


public struct ISO8601DateTransformer: ValueTransformable {
    public typealias JSON = String
    public typealias Object = Date
    
    let dateFormatter: DateFormatter

    public init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }

    public func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            let date = dateFormatter.date(from: dateString)
            return date
        }
        return nil
    }

    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
