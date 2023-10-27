//
//  ViewController.swift
//  SmartCodable
//
//  Created by mancong@bertadata.com on 08/08/2023.
//  Copyright (c) 2023 mancong@bertadata.com. All rights reserved.
//

import UIKit
import SmartCodable


func isTypeDictionary<T: Decodable>(type: T.Type) -> Bool {
    return T.self is Dictionary<String, String>.Type
}

// 示例用法
struct Person123: Decodable {
    let name: String
    let age: Int
}



struct ABCTest {
    var name: String
}

class ViewController: UIViewController {
    
    
    var dataArray: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .error
        SmartConfig.openErrorAssert = false
        
        dataArray = [smart_introduce, smart_compatible, smart_compatible_structure, smart_speciale, smart_case, smart_disadvantage, other]
        
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    
    lazy var tableView = UITableView.make(registerCells: [UITableViewCell.self], delegate: self, style: .grouped)
}


extension ViewController {
    
    var smart_introduce: [String: Any] {
        [
            "title": "Smart介绍",
            "list": [
                ["name": "简单实用", "vc": "SimpleSmartCodableViewController"],
                ["name": "字典 ⇆ 模型", "vc": "DictionaryAndModelViewController"],
                ["name": "数组 ⇆ 模型数组", "vc": "ArrayAndModelViewController"],
                ["name": "解码完成的回调", "vc": "FinishMappingViewController"],
                ["name": "字段名映射", "vc": "FieldNameMapViewController"],
                ["name": "可选对象属性", "vc": "OptionalPropertyViewController"],
                ["name": "复杂数据结构", "vc": "ComplexDataStructureViewController"],
            ]
        ]
    }
    
    
    var smart_compatible: [String: Any] {
        [
            "title": "Smart兼容性 - 验证类型兼容",
            "list": [
                ["name": "无键的情况", "vc": "CompatibleKeylessViewController"],
                ["name": "值类型不匹配", "vc": "CompatibleTypeMismatchViewController"],
                ["name": "空对象", "vc": "CompatibleEmptyObjectViewController"],
                ["name": "null", "vc": "CompatibleNullViewController"],
                ["name": "enum", "vc": "CompatibleEnumViewController"],
                ["name": "浮点数", "vc": "CompatibleFloatViewController"],
                ["name": "Bool", "vc": "CompatibleBoolViewController"],
                ["name": "String", "vc": "CompatibleStringViewController"],
                ["name": "Int", "vc": "CompatibleIntViewController"],
                ["name": "模型Model", "vc": "CompatibleClassViewController"],
            ]
        ]
    }
    
    // 兼容性 - 不同结构下的
    var smart_compatible_structure: [String: Any] {
       [
        "title": "Smart兼容性 - 不同数据结构",
        "list": [
            ["name": "字典 -> String", "vc": "CompatibleSampleOneViewController"],
            ["name": "字典 -> 字典 -> String", "vc": "CompatibleSampleTwoViewController"],
            ["name": "字典 -> 数组 -> 字典 -> String", "vc": "CompatibleSampleThreeViewController"],
            ["name": "字典 -> 数组 -> 字典 -> 字典 -> String", "vc": "CompatibleSampleFourViewController"],

            ["name": "数组 -> 字典 -> String", "vc": "CompatibleSampleFiveViewController"],
            ["name": "数组 -> 字典 -> 数组 -> 字典 -> String", "vc": "CompatibleSampleSixViewController"],
        ]
       ]
    }
    
    
    
    
    var smart_speciale: [String: Any] {
        [
            "title": "Smart调试信息",
            "list": [
                ["name": "日志等级", "vc": "DecodeErrorPrintViewController"],
                ["name": "解码错误信息", "vc": "DecodeErrorPrintViewController"],
            ]
        ]
    }
    
    var smart_case: [String: Any] {
        [
            "title": "Smart案例",
            "list": [
                ["name": "扁平化", "vc": "CaseOneViewController"],
                ["name": "派生关系", "vc": "CaseTwoViewController"],
            ]
        ]
    }
    
    
    var smart_disadvantage: [String: Any] {
        [
            "title": "Smart缺点",
            "list": [
                ["name": "Any无法使用", "vc": "AboutAnyViewController"],
                ["name": "默认值无效", "vc": "InvalidDefaultValueController"],
            ]
        ]
    }
    
    
    var other: [String: Any] {
        [
            "title": "测试",
            "list": [
                ["name": "测试代码", "vc": "TestViewController"],
            ]
        ]
    }
}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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



extension ViewController {
    
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
