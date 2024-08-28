//
//  DecodingStrategyViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/3/26.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit


/** 解码策略
 * 解析前：
 * - key的解析忽略
 *
 * 解析中：值解码策略
 * - 全局性
 * - 局部性
 *
 * 解析后
 * - 解码完成的回调
 */

class DecodingStrategyViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "解码策略"
        

        dataArray = [
            caseOne,
            caseTwo,
            caseThree,
        ]
        
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    var dataArray: [[String: Any]] = []

    lazy var tableView = UITableView.make(registerCells: [UITableViewCell.self], delegate: self, style: .grouped)

}



extension DecodingStrategyViewController {
    
    var caseOne: [String: Any] {
        [
            "title": "解码前的策略",
            "list": [
                ["name": "忽略某些Key的解析",  "vc": "BeforeDecodingViewController"],
            ]
        ]
    }
    
    var caseTwo: [String: Any] {
        [
            "title": "解码中的策略",
            "list": [
                ["name": "[全局策略] key解析策略",   "vc": "KeyDecodingStrategyViewController"],
                ["name": "[全局策略] Data解析策略",  "vc": "DataDecodingStrategyViewController"],
                ["name": "[全局策略] 浮点数解析策略", "vc": "FloatDecodingStrategyViewController"],
                ["name": "[全局策略] Date解析策略",  "vc": "DateDecodingStrategyViewController"],

                ["name": "[局部策略] 自定义解析路径",   "vc": "CustomDecodingKeyViewContriller"],
                ["name": "[局部策略] Key的重命名",     "vc": "CustomDecodingKeyViewContriller"],
                ["name": "[局部策略] Value的解析策略", "vc":   "CustomDecodingValueViewContriller"],
                ["name": "[局部策略] 自定义路径+全局Key映射+局部key映射混用",
                 "vc":   "MixDecodingViewController"],
            ]
        ]
    }
    
    var caseThree: [String: Any] {
        [
            "title": "解码后的策略",
            "list": [
                ["name": "解码完成的回调",     "vc": "FinishMappingViewController"],
            ]
        ]
    }
}




extension DecodingStrategyViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        present(vc, animated: true)
    }
    
}




extension DecodingStrategyViewController {
    
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
