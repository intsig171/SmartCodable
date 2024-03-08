//
//  File.swift
//  SmartCodable_Example
//
//  Created by qixin on 2023/9/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ComplexDataStructureSectionHeader: UITableViewHeaderFooterView {
    
    var model: Class = Class() {
        didSet {
            nameLabel.text = model.name
            countLabel.text = "\(model.number)人"
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
}



extension ComplexDataStructureSectionHeader {
    
    func createUI() {
        contentView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.bottom.equalTo(nameLabel)
        }
    }
}



class ComplexDataStructureSectionFooter: UITableViewHeaderFooterView {
    
   

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
