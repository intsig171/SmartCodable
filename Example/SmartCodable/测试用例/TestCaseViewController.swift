//
//  TestCaseViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/2/29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class TestCaseViewController: BaseViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SmartCodable测试用例"
        
       
        
        dataArray = [
            testCaseOne,
            testCaseThree,
            testCaseTwo,
            testCaseFour,
            testCaseFive

        ]
        
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    var dataArray: [[String: Any]] = []

    lazy var tableView = UITableView.make(registerCells: [UITableViewCell.self], delegate: self, style: .grouped)

}



extension TestCaseViewController {
    
    var testCaseOne: [String: Any] {
        [
            "title": "CaseOne - 基础数据测试",
            "list": [
                ["name": "类型兼容 - Bool",   "vc": "BaseData_BoolViewController"],
                ["name": "类型兼容 - Int",    "vc": "BaseData_IntViewController"],
                ["name": "类型兼容 - Int8",   "vc": "BaseData_Int8ViewController"],
                ["name": "类型兼容 - String", "vc": "BaseData_StringViewController"],
                ["name": "类型兼容 - Float",  "vc": "BaseData_FloatViewController"],

            
                

                
                
                
            ]
        ]
    }
    
    
    var testCaseTwo: [String: Any] {
        [
            "title": "CaseTwo - 嵌套数据测试",
            "list": [
                ["name": "字典",            "vc": "Container_DictViewController"],
                ["name": "字典 - 键缺失",    "vc": "Container_DictKeylessViewController"],
                ["name": "字典 - 值为null",  "vc": "Container_DictNullViewController"],
                ["name": "字典 - 值类型错误", "vc": "Container_DictTypeMismatchViewController"],
                ["name": "字典 - 嵌套字典",   "vc": "Container_DictNestDictViewController"],
                ["name": "字典 - 嵌套数组",   "vc": "Container_DictNestArrayViewController"],
                
                ["name": "数组",            "vc": "Container_ArrayViewController"],
                ["name": "数组 - 键缺失",    "vc": "Container_ArrayKeylessViewController"],
                ["name": "数组 - 值为null",  "vc": "Container_ArrayNullViewController"],
                ["name": "数组 - 值类型错误", "vc": "Container_ArrayTypeMismatchViewController"],
                ["name": "数组 - 嵌套字典",   "vc": "Container_ArrayNestDictViewController"],
                ["name": "数组 - 嵌套数组",   "vc": "Container_ArrayNestArrayViewController"],
            ]
        ]
    }
    
    var testCaseThree: [String: Any] {
        [
            "title": "CaseThree - 特殊格式数据测试",
            "list": [
                ["name": "特殊格式 - Date",       "vc": "SpecialData_dateViewController"],
                ["name": "特殊格式 - Data",       "vc": "SpecialData_dataViewController"],
                ["name": "特殊格式 - Float",      "vc": "SpecialData_FloatViewController"],
                ["name": "特殊格式 - URL",        "vc": "SpecialData_URLViewController"],
                ["name": "特殊格式 - Enum",       "vc": "SpecialData_EnumViewController"],
                ["name": "特殊格式 - SmartColor", "vc": "SpecialData_ColorViewController"],
                ["name": "特殊格式 - SmartAny",   "vc": "SpecialData_SmartAnyViewController"],

            ]
        ]
    }
    
    var testCaseFour: [String: Any] {
        [
            "title": "CaseFour - 功能性测试",
            "list": [
                ["name": "功能性 - 解码完成的回调",  "vc": "Support_didFinishMappingViewController"],
                ["name": "特殊格式 - json数据",    "vc": "Support_JSONStringViewController"],

            ]
        ]
    }
    
    
    var testCaseFive: [String: Any] {
        [
            "title": "CaseFive - 解码关系",
            "list": [
                ["name": "解码关系 - 忽略Key的解析",    "vc": "Decoding_keyIgnoreViewController"],
                ["name": "解码关系 - key的映射(mappingForKey)",    "vc": "Decoding_keyMapViewController"],

                
                ["name": "解码关系 - key的映射(Strategy)",  "vc": "Decoding_globalKeyStrategyViewController"],
                ["name": "Key全局策略 - 蛇形命名转驼峰",    "vc": "CaseFive_wcdbViewController"],


            ]
        ]
    }
}




extension TestCaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dict = dataArray[section~] {
            let list = dict["list"] as? [[String: String]] ?? []
            return list.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let dict = dataArray[section~] {
            let title = dict["title"] as? String
            return title
        }
        return ""
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.makeCell(indexPath: indexPath)
        
        if let dict = dataArray[indexPath.section~] {

            let list = dict["list"] as? [[String: String]] ?? []
            
            let inDict = list[indexPath.row~] ?? [:]
            cell.textLabel?.text = inDict["name"] ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let dict = dataArray[indexPath.section~] else { return }
        guard let list = dict["list"] as? [[String: String]] else { return }
        guard let inDict = list[indexPath.row~] else { return }

        let vcStr = inDict["vc"] ?? ""
        let name = inDict["name"] ?? ""
        guard let vc = createViewControllerObject(form: vcStr) else { return }
        vc.contentText = name
        
        present(vc, animated: true)
    }
    
}




extension TestCaseViewController {
    
    func createViewControllerObject(form className: String) -> BaseViewController? {
        let projectName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        let classStringName = projectName + "." + className
        if let viewControllerClass = NSClassFromString(classStringName) as? BaseViewController.Type {
            let viewController = viewControllerClass.init()
            return viewController
        } else {
            return nil
        }
    }
}
