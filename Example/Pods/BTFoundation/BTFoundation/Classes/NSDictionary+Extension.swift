//
//  NSDictionary+Extension.swift
//  BTFoundation
//
//  Created by Jason on 23/4/2020.
//

import Foundation

extension Dictionary {
    /// 字典转Json字符串
    public func bt_toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return json
        } catch {
            return nil
        }
    }
}


extension Dictionary {
    /// 字典拼接 (必须要同类型)
    public mutating func append(_ dict: Dictionary) {
        dict.forEach { (key, value) in
            self.updateValue(value, forKey: key)
        }
    }
}
