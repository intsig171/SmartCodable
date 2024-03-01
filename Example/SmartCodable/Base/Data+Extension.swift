//
//  Data+Extension.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/3/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation


extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}
