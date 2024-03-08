//
//  ViewController.swift
//  SmartCodable
//
//  Created by Mccc on 08/08/2023.
//  Copyright (c) 2023 Mccc. All rights reserved.
//

import UIKit
import SmartCodable


func isTypeDictionary<T: Decodable>(type: T.Type) -> Bool {
    return T.self is Dictionary<String, String>.Type
}


class ViewController: UIViewController {
    
    
    var dataArray: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SmartCodable"
        
        SmartConfig.openErrorAssert = false
        
        dataArray = [
            other,
            smart_test,
            smart_introduce,
            smart_Strength,
            smart_customDecoding,
            smart_debug,
            smart_case,
        ]
        
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    
    lazy var tableView = UITableView.make(registerCells: [UITableViewCell.self], delegate: self, style: .grouped)
}


extension ViewController {
    
    var smart_test: [String: Any] {
        [
            "title": "Smart的测试用例",
            "list": [
                ["name": "丰富的测试用例 >>>", "vc": "TestCaseViewController"],
            ]
        ]
    }
    
    
    var smart_introduce: [String: Any] {
        [
            "title": "Smart使用介绍",
            "list": [
                ["name": "简单使用",       "vc": "Introduce_1ViewController"],
                ["name": "字典 ⇆ 模型",    "vc": "Introduce_2ViewController"],
                ["name": "数组 ⇆ 模型数组", "vc": "Introduce_3ViewController"],
                ["name": "属性对象的解析",  "vc": "Introduce_4ViewController"],
            ]
        ]
    }
    
    
    
    var smart_Strength: [String: Any] {
        [
            "title": "Smart的强大之处",
            "list": [
                ["name": "支持Any解析",             "vc": "Strength_1ViewController"],
                ["name": "支持解码完成的回调",        "vc": "Strength_2ViewController"],
                ["name": "支持解码时Key的映射",       "vc": "Strength_3ViewController"],
                ["name": "支持默认值填充",            "vc": "Strength_4ViewController"],
                ["name": "支持json字段值的对象化解析", "vc": "Strength_5ViewController"],
                ["name": "支持枚举项的解析兼容",       "vc": "Strength_6ViewController"],

            ]
        ]
    }
    
    
    var smart_customDecoding: [String: Any] {
        [
            "title": "Smart的解码策略",
            "list": [
                ["name": "Date的解码策略", "vc": "DateDecodingStrategyViewController"],
                ["name": "Data的解码策略", "vc": "DataDecodingStrategyViewController"],
                ["name": "浮点数的解码策略", "vc": "FloatDecodingStrategyViewController"],
            ]
        ]
    }


    
    var smart_debug: [String: Any] {
        [
            "title": "Smart调试信息",
            "list": [
                ["name": "日志等级 & 日志信息", "vc": "DecodingLogViewController"],
            ]
        ]
    }
    
    var smart_case: [String: Any] {
        [
            "title": "Smart案例",
            "list": [
                ["name": "扁平化", "vc": "CaseOneViewController"],
                ["name": "Model继承", "vc": "CaseTwoViewController"],
                ["name": "多值映射", "vc": "CaseThreeViewController"],
                ["name": "范型解析", "vc": "CaseFourViewController"],
                ["name": "范型解析 - signle value", "vc": "CaseFiveViewController"],
                ["name": "复杂场景的解析", "vc": "CaseSixViewController"],
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.backgroundColor = UIColor.red.withAlphaComponent(0.01)
        
        if let dict = dataArray[section~] {
            let title = dict["title"] as? String ?? ""
            label.text = "    " + title
        }
        
        return label
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
        
        navigationController?.pushViewController(vc, animated: true)
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
