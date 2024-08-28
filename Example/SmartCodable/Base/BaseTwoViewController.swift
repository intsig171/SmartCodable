//
//  BaseTwoViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/1/22.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class BaseTwoViewController: BaseViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(40)
            make.height.equalTo(50)
        }
        
        contentLabel.font = .systemFont(ofSize: 16)
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.lessThanOrEqualTo(-40)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
}
