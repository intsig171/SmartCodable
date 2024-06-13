//
//  IntroduceViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class IntroduceViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "使用介绍"
        

        dataArray = [
            smart_introduce,
        ]
        
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    var dataArray: [[String: Any]] = []

    lazy var tableView = UITableView.make(registerCells: [UITableViewCell.self], delegate: self, style: .grouped)

}



extension IntroduceViewController {
    
    var smart_introduce: [String: Any] {
        [
            "title": "Smart使用介绍",
            "list": [
                ["name": "1. 简单使用",       "vc": "Introduce_1ViewController"],
                ["name": "2. 字典 ⇆ 模型",    "vc": "Introduce_2ViewController"],
                ["name": "3. 数组 ⇆ 模型数组", "vc": "Introduce_3ViewController"],
                ["name": "4. 属性对象的解析",  "vc": "Introduce_4ViewController"],
                ["name": "5. 解析包含Any的数据类型(SamrtAny)",  "vc": "Introduce_5ViewController"],
                ["name": "6. 解析失败，支持初始值填充",  "vc": "Introduce_6ViewController"],
                ["name": "7. 支持json字段的对象化解析",  "vc": "Introduce_7ViewController"],
                ["name": "8. 支持枚举的解析",  "vc": "Introduce_8ViewController"],
                ["name": "9. 支持UIColor的解析",  "vc": "Introduce_9ViewController"],
                ["name": "10. 指定解析路径",  "vc": "Introduce_10ViewController"],
                ["name": "11. 更新现有模型",  "vc": "Introduce_11ViewController"],


            ]
        ]
    }
}




extension IntroduceViewController: UITableViewDelegate, UITableViewDataSource {
    
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




extension IntroduceViewController {
    
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
