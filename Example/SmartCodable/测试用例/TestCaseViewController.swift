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
                ["name": "字典 - 键缺失",    "vc": "CaseOne_DictKeylessViewController"],
                ["name": "字典 - 值为null",  "vc": "CaseOne_DictNullViewController"],
                ["name": "字典 - 值类型错误", "vc": "CaseOne_DictTypeMismatchViewController"],
                
                ["name": "数组 - 键缺失",    "vc": "CaseTwo_ArrKeylessViewController"],
                ["name": "数组 - 值为null",  "vc": "CaseTwo_ArrNullViewController"],
                ["name": "数组 - 值类型错误", "vc": "CaseTwo_ArrTypeMismatchViewController"],
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
