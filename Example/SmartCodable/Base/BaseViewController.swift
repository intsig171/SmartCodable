//
//  BaseViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/8/9.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable



class BaseViewController: UIViewController {
    
    var contentText: String = "" {
        didSet {
            contentLabel.text = contentText + "\n\n 请查看控制台输出"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        
        contentLabel.frame = view.bounds
        contentLabel.frame.size.height = 200
        view.addSubview(contentLabel)
    }
    
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
}

extension BaseViewController {
    func printValueType(key: String, value: Any?) {
        
        if let temp = value {
            debugPrint("属性：\(key) 的类型是 \(type(of: temp))， 其值为 \(temp)")
        } else {
            debugPrint("属性：\(key) 的值为nil")
        }
    }
    
    func smartPrint(value: Any?) {
        
        guard let value = value else { return }
        debugPrint("\(type(of: value))的属性打印信息：")
        let mirr = Mirror(reflecting: value)
        for (key, value) in mirr.children {
            printValueType(key: key ?? "", value: value)
        }
        
        print("\n")
    }

}



extension Array {
    public func decode<T: Decodable>(type: [T].Type) -> [T]? {
        do {
            guard let jsonStr = self.bt_toJSONString() else { return nil }
            guard let jsonData = jsonStr.data(using: .utf8) else { return nil }
            let decoder = JSONDecoder()
            let obj = try decoder.decode(type, from: jsonData)
            return obj
        } catch let error {
            print(error)
            return nil
        }
    }
}


extension Dictionary {
    public func decode<T: Decodable>(type: T.Type) -> T? {
        do {
            guard let jsonStr = self.toJSONString() else { return nil }
            guard let jsonData = jsonStr.data(using: .utf8) else { return nil }
            let decoder = SmartJSONDecoder()
            decoder.dateDecodingStrategy = .deferredToDate
            let obj = try decoder.decode(type, from: jsonData)
            return obj
        } catch let error {
            print(error)
            return nil
        }
    }
    
    private func toJSONString() -> String? {
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


extension String {
    public func decode<T: Decodable>(type: T.Type) -> T? {
        guard let jsonData = self.data(using: .utf8) else { return nil }
        
        do {
            let decoder = JSONDecoder()
            
            
            
            let feed = try decoder.decode(type, from: jsonData)
            return feed
        } catch let error {
            print(error)
            return nil
        }
    }
    
    public func toDictionary() -> [String: Any]? {
        if let jsonData = data(using: .utf8) {
            do {
                // 尝试反序列化JSON数据到字典
                if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    return dictionary
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    public func toArray() -> [[String: Any]]? {
        if let jsonData = data(using: .utf8) {
            do {
                // 尝试反序列化JSON数据到数组
                if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                    return array
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}


extension Encodable {
    public func encode() -> Any? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            guard let value = String(data: data, encoding: .utf8) else { return nil }
            return value
        } catch {
            print(error)
        }
        return nil
    }
}
