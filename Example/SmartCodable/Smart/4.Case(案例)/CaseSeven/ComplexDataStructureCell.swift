//
//  ComplexDataStructureDetailView.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/9/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ComplexDataStructureDetailCell: UITableViewCell {
    
    var model: Student = Student() {
        didSet {
            nameLabel.text = "姓名：" + model.name
            idLabel.text = "学号：" + "\(model.id)"
            sexLabel.text = "性别：" + model.sex.rawValue
            areaLabel.text = "籍贯：" + model.area
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(16)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(16)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(sexLabel)
        sexLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom)
            make.left.equalTo(16)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(areaLabel)
        areaLabel.snp.makeConstraints { make in
            make.top.equalTo(sexLabel.snp.bottom)
            make.left.equalTo(16)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        return label
    }()


    lazy var idLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var sexLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var areaLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.gray
        return line
    }()
}
