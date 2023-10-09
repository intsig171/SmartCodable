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
    
    
    var dataArray: [[[String: String]]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .error
        SmartConfig.openErrorAssert = false
        
        dataArray = [ smart_introduceJsonArr, smart_compatibleArr, smart_specialeArr, smart_caseArr, smart_disadvantageArr, otherArr]

    
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    
    lazy var tableView = UITableView.make(registerCells: [UITableViewCell.self], delegate: self, style: .grouped)
}


extension ViewController {
    
    var smart_introduceJsonArr: [[String: String]] {
        [
            ["name": "Smart介绍 - 简单实用", "vc": "SimpleSmartCodableViewController"],
            ["name": "Smart介绍 - 字典 ⇆ 模型", "vc": "DictionaryAndModelViewController"],
            ["name": "Smart介绍 - 数组 ⇆ 模型数组", "vc": "ArrayAndModelViewController"],
            ["name": "Smart介绍 - 解码完成的回调", "vc": "FinishMappingViewController"],
            ["name": "Smart介绍 - 字段名映射", "vc": "FieldNameMapViewController"],
            ["name": "Smart介绍 - 可选对象属性", "vc": "OptionalPropertyViewController"],
            ["name": "Smart介绍 - 复杂数据结构", "vc": "ComplexDataStructureViewController"],
        ]
    }
    
    
    var smart_compatibleArr: [[String: String]] {
        [
            ["name": "Smart兼容性 - 无对应键", "vc": "CompatibleKeylessViewController"],
            ["name": "Smart兼容性 - 值类型不匹配", "vc": "CompatibleTypeMismatchViewController"],
            ["name": "Smart兼容性 - 空对象", "vc": "CompatibleEmptyObjectViewController"],
            ["name": "Smart兼容性 - null", "vc": "CompatibleNullViewController"],
            ["name": "Smart兼容性 - enum", "vc": "CompatibleEnumViewController"],
            ["name": "Smart兼容性 - 浮点数", "vc": "CompatibleFloatViewController"],
            ["name": "Smart兼容性 - Bool", "vc": "CompatibleBoolViewController"],
            ["name": "Smart兼容性 - String", "vc": "CompatibleStringViewController"],
            ["name": "Smart兼容性 - Int", "vc": "CompatibleIntViewController"],
            ["name": "Smart兼容性 - sturct & class", "vc": "CompatibleClassViewController"],
        ]
    }
    
    
    var smart_specialeArr: [[String: String]] {
        [
            ["name": "Smart调试信息 - 日志等级", "vc": "DecodeErrorPrintViewController"],
            ["name": "Smart调试信息 - 解码错误信息", "vc": "DecodeErrorPrintViewController"],
        ]
    }
    
    var smart_caseArr: [[String: String]] {
        [
            ["name": "Smart案例 - 扁平化", "vc": "CaseOneViewController"],
            ["name": "Smart案例 - 扁平化", "vc": "CaseOneViewController"],
        ]
    }
    
    
    var smart_disadvantageArr: [[String: String]] {
        [
            ["name": "Smart缺点 - Any无法使用", "vc": "AboutAnyViewController"],
            ["name": "Smart缺点 - 默认值无效", "vc": "InvalidDefaultValueController"],
        ]
    }
    
        
    var otherArr: [[String: String]] {
        [
            ["name": "测试代码", "vc": "TestViewController"],
        ]
    }
}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = dataArray[section~] {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.makeCell(indexPath: indexPath)
        
        if let arr = dataArray[indexPath.section~] {
            
            let dict = arr[indexPath.row~] ?? [:]
            cell.textLabel?.text = dict["name"] ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        guard let arr = dataArray[indexPath.section~] else { return }
        guard let dict = arr[indexPath.row~] else { return }
        let vcStr = dict["vc"] ?? ""
        let name = dict["name"] ?? ""
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
