//
//  UINavigationItem+Config.Swift
//  pluto
//
//  Created by Allen on 2020/6/17.
//  Copyright © 2020 bertadata. All rights reserved.
//  提供一种图片+文字+图片展示方式的自定义view

import SnapKit
import BTFoundation

open class BTNavigationCustomTitleView: UIView {
    
    public enum position {
        case left
        case right
        case middle
    }
    
    /// 获取到的图片的类型
    public enum CustomImgType {
        case localImage(UIImage,[String: Any])
        case webImage(String, [String: Any])
        
        func getParam() -> [String: Any] {
            switch self {
            case .localImage(_, let param): return param
            case .webImage(_, let param): return param
            }
        }
    }
    
    public typealias customAction = (position, [String: Any]) -> ()
    
    public var block: customAction? = nil
    
    private var leftImageView: UIImageView? = nil
    private var rightImageView: UIImageView? = nil
    private var middleLabel: UILabel = UILabel()
    
    private var leftParam: [String: Any] = [:]
    private var rightParam: [String: Any] = [:]

    /// 提供的自定义图片+文字+图片样式： 文字在父view上居中显示，图片在两边
    public convenience init(leftImgType: CustomImgType?, middleTitle: String, rightImgType: CustomImgType?, actionBlock: customAction? = nil) {
        self.init(frame: .init(x: 0, y: 0, width: 44, height: 44))
        
        block = actionBlock
        
        let titleLabel = createLabel(title: middleTitle)
        let titleTap = UITapGestureRecognizer.init(target: self, action: #selector(didClickMiddle))
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(titleTap)
        addSubview(titleLabel)
        self.middleLabel = titleLabel

        if let leftType = leftImgType {
            
            leftParam = leftType.getParam()
            
            let leftImgView = createImageView(type: leftType)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(didClickLeft))
            leftImgView.isUserInteractionEnabled = true
            leftImgView.addGestureRecognizer(tap)
            
            addSubview(leftImgView)
            self.leftImageView = leftImgView
        } else {
            leftParam = [:]
        }

        if let rightType = rightImgType {
            
            rightParam = rightType.getParam()
            
            let rightImgView = createImageView(type: rightType)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(didClickRight))
            rightImgView.isUserInteractionEnabled = true
            rightImgView.addGestureRecognizer(tap)
            
            addSubview(rightImgView)
            self.rightImageView = rightImgView
        } else {
            rightParam = [:]
        }
    }
    
    public func update(maxWidth: CGFloat) {
                
        frame.size.width = maxWidth
        
        var leftWidth: CGFloat = 0
        if let leftView = leftImageView {
            leftWidth = leftView.frame.size.width + 5
        }
        
        var rightWidth: CGFloat = 0
        if let rightView = rightImageView {
            rightWidth = rightView.frame.size.width + 5
        }
                
        var labelWidth: CGFloat = 0
        if leftWidth > rightWidth {
            /// label显示居中最大允许的宽度
            let labelMaxWidth = (maxWidth/2 - leftWidth)*2
            labelWidth = min(labelMaxWidth, middleLabel.frame.size.width)
        } else {
            /// label显示居中最大允许的宽度
            let labelMaxWidth = (maxWidth/2 - rightWidth)*2
            labelWidth = min(labelMaxWidth, middleLabel.frame.size.width)
        }
        
        middleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(labelWidth)
            make.height.equalTo(middleLabel.frame.size.height)
        }
        
        if let leftImageObjc = leftImageView {
            leftImageObjc.snp.makeConstraints { make in
                make.right.equalTo(middleLabel.snp.left).offset(-5)
                make.size.equalTo(leftImageObjc.frame.size)
                make.centerY.equalToSuperview()
            }
        }
        
        if let rightImageObjc = rightImageView {
            rightImageObjc.snp.makeConstraints { make in
                make.left.equalTo(middleLabel.snp.right).offset(5)
                make.size.equalTo(rightImageObjc.frame.size)
                make.centerY.equalToSuperview()
            }
        }
    }
}

// MARK: - actions
extension BTNavigationCustomTitleView {
    
    @objc private func didClickLeft() {
        block?(.left, self.leftParam)
    }
    
    @objc private func didClickMiddle() {
        block?(.middle, [:])
    }
    
    @objc private func didClickRight() {
        block?(.right, self.rightParam)
    }
}

// MARK: - private func
extension BTNavigationCustomTitleView {
    
    /// 创建文本Label
    private func createLabel(title: String) -> UILabel {
        let titleLabel: UILabel = UILabel.init(frame: .zero)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.init(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        titleLabel.text = title
        titleLabel.sizeToFit()
        return titleLabel
    }
    
    /// 创建图片view
    private func createImageView(type: CustomImgType) -> UIImageView {
        
        switch type {
        case .localImage(let img, _):
            let imgView = UIImageView.init(image: img)
            if img.size.height <= 44 {
                imgView.sizeToFit()
            } else {
                let newWidth = 44 * img.size.width / img.size.height
                imgView.frame.size = .init(width: newWidth, height: 44)
            }
            return imgView
            
        case .webImage(let url, _):
            let imgView = UIImageView()
            let bundle = Bundle.bt.getBundleWithName("BTUIKitUINavigationItemBundle", inPod: "BTUIKit")
            let placeHolderImage = UIImage.bt.loadImage("nav_more", inBundle: bundle)
            imgView.kf.setImage(with: URL.init(string: url), placeholder: placeHolderImage)
            imgView.frame.size = .init(width: 44, height: 44)
            return imgView
        }
    }
}
