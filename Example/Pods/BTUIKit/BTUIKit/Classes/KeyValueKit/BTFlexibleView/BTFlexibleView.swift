//
//  BTFlexibleView.swift
//  swiftTest
//
//  Created by Allen on 2020/6/11.
//  Copyright © 2020 Allen. All rights reserved.
//  带有展开收起功能的label

import UIKit
import SnapKit

/// 存储展开收起按钮样式和位置的结构体
public struct BTLabelFlexConfig {
    public var type: UILabel.BTLabelSuffixButtonType = .none
    public var position: UILabel.BTLabelSuffixButtonPosition = .rightBottom
}

open class BTFlexibleView: BTLimitRowLabel {
        
    public var config: BTLabelFlexConfig = .init(type: .none, position: .rightBottom)
    
    open override var text: String? {
        
        willSet {
            // 每次修改text重置之前缓存的数据，防止在cell列表滑动切换数据的时候显示错误
            isOpen = false
            additionalHeight = 0
            
            if originalLimitedRow > 0 {
                limitedRow = originalLimitedRow
                originalLimitedRow = -1
            }
        }
    }
    
    open override var attributedText: NSAttributedString? {
        
        willSet {
            // 每次修改text重置之前缓存的数据，防止在cell列表滑动切换数据的时候显示错误
            isOpen = false
            additionalHeight = 0
            
            if originalLimitedRow > 0 {
                limitedRow = originalLimitedRow
                originalLimitedRow = -1
            }
        }
    }
    
    public weak var btnActionDelegate: BTFlexibleFlexDelegate? = nil

    public weak var btnStyleDataSource: BTFlexibleViewSuffixBtnStyleDataSource? = nil {
        didSet {
            if let _ = btnStyleDataSource {
                stuffixBtn.frame.size = btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20)
                stuffixBtn.setTitleColor(btnStyleDataSource?.textColorForSuffixButton(isOpen: isOpen) ?? .blue, for: UIControl.State.normal)
                stuffixBtn.titleLabel?.font = btnStyleDataSource?.textFontForSuffixButton(isOpen: isOpen) ?? UIFont.systemFont(ofSize: 14)
                stuffixBtn.backgroundColor = btnStyleDataSource?.backGroundColorForSuffixButton(isOpen: isOpen) ?? .red
                btnStyleDataSource?.makeCustomSetting(suffixBtn: stuffixBtn)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stuffixBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        btn.addTarget(self, action: #selector(didClickStuffixBtn), for: .touchUpInside)
        return btn
    }()
    
    open override func updateConstraints() {
        
        super.updateConstraints()
        
        if additionalHeight > 0 {
            
            let totalSize = selfSize()
            
            // 根据布局类型使用相应方式刷新UI
            switch layoutStyle {
            
            case .useframe(_):
                frame.size = totalSize

            case .useConstraints:
                self.snp.updateConstraints { make in
                    make.height.equalTo(totalSize.height)
                }
            }
        }
    }
    
    private var isOpen: Bool = false
    
    /// 保存一份设置的限制行数，方便在收起修改行数的时候恢复
    private var originalLimitedRow: Int = -1
    
    /// 用于展开收起按钮在底部展示的时候需要增加高度
    private var additionalHeight: CGFloat = 0
    
    /// 重写获取selfSize方法，获取最准确的size
    public override func selfSize() -> CGSize {
        let contentSize = super.selfSize()
        return .init(width: contentSize.width, height: contentSize.height + additionalHeight)
    }
    
}

// MARK: - public

extension BTFlexibleView {
    
    /// 控制当前按钮展开收起
    public func updateSuffixBtnStatus(_ isOpen: Bool) {
        self.isOpen = isOpen
        
        //当前还没有展开收起过，当前获取到的limitedRow是开发者设置的
        if originalLimitedRow < 0 {
            originalLimitedRow = limitedRow
        }
        
        if isOpen {
            //打开状态下完全展示
            limitedRow = 0
        } else {
            //关闭状态下显示部分行
            limitedRow = originalLimitedRow
        }
    }
}

// MARK: - private
extension BTFlexibleView {
        
    public override func refreshLabel() {
        super.refreshLabel()
        
        additionalHeight = 0
        
        if config.type != .none {
            
            stuffixBtn.isHidden = false
            
            let linesArray = getMaxLineCount(size: CGSize.init(width: maxWidth, height: CGFloat(MAXFLOAT))) as NSArray
            
            if config.type == .onlyOpen && isOpen == true {
                stuffixBtn.isHidden = true
            }
            
            if isOpen == false {
                if (originalLimitedRow < 0 && linesArray.count <= limitedRow) || (originalLimitedRow > 0 && linesArray.count <= originalLimitedRow) {
                    stuffixBtn.isHidden = true
                }
            }
            
            switch (config.type, config.position) {
            
            case (.onlyOpen,.rightBottom):
                
                if !isOpen && !stuffixBtn.isHidden {
                    stuffixBtn.snp.remakeConstraints { make in
                        make.right.bottom.equalTo(0)
                        make.size.equalTo(btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20))
                    }
                }
                
            case (.onlyOpen,.middleBottom(let margin)):
                
                if !isOpen && !stuffixBtn.isHidden {
                    
                    stuffixBtn.snp.remakeConstraints { make in
                        make.centerX.equalTo(self)
                        make.bottom.equalTo(self)
                        make.size.equalTo(btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20))
                    }
                    additionalHeight = margin + stuffixBtn.frame.size.height
                }
                
            case (.onlyOpen,.followBottomLine(_)):
                
                if !isOpen && !stuffixBtn.isHidden {
                    
                    //折叠并且当前跟随最后一行文本展示的情况下，按钮肯定是被顶在最右下角，和rightBottom一致
                    stuffixBtn.snp.remakeConstraints { make in
                        make.right.bottom.equalTo(0)
                        make.size.equalTo(btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20))
                    }
                }
                
            case (.openAndClose,.rightBottom):
                
                stuffixBtn.snp.remakeConstraints { make in
                    make.right.bottom.equalTo(0)
                    make.size.equalTo(btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20))
                }
                
            case (.openAndClose,.middleBottom(let margin)):
                
                if !stuffixBtn.isHidden {
                    stuffixBtn.snp.remakeConstraints { make in
                        make.centerX.equalTo(self)
                        make.bottom.equalTo(self)
                        make.size.equalTo(btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20))
                    }
                    additionalHeight = margin + stuffixBtn.frame.size.height
                }
                
            case (.openAndClose,.followBottomLine(let margin)):
                
                if !isOpen {
                    stuffixBtn.snp.remakeConstraints { make in
                        make.right.bottom.equalTo(0)
                        make.size.equalTo(btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20))
                    }
                } else {
                    
                    let lastLine = linesArray.lastObject as! CTLine
                    let lineWidth:CGFloat = CGFloat(lastLine.width())
                    
                    if lineWidth + margin + stuffixBtn.frame.size.width > maxWidth {
                        stuffixBtn.snp.remakeConstraints { make in
                            make.right.bottom.equalTo(0)
                            make.size.equalTo(btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20))
                        }
                    } else {
                        stuffixBtn.snp.remakeConstraints { make in
                            make.left.equalTo(lineWidth + margin)
                            make.bottom.equalTo(0)
                            make.size.equalTo(btnStyleDataSource?.sizeForSuffixButton(isOpen: isOpen) ?? CGSize(width: 30, height: 20))
                        }
                    }
                }
            default:
                break
            }
            
            if !stuffixBtn.isHidden {
                if let suffixBtnString = btnStyleDataSource?.textForSuffixButton(isOpen: isOpen) {
                    stuffixBtn.setTitle(suffixBtnString, for: .normal)
                } else {
                    if isOpen {
                        stuffixBtn.setTitle("收起", for: .normal)
                    } else {
                        stuffixBtn.setTitle("展开", for: .normal)
                    }
                }
            }
            
        } else {
            stuffixBtn.isHidden = true
        }
        
        /// 告知系统需要更新约束，保证会在将来触发一次updateConstraints方法
        self.setNeedsUpdateConstraints()
    }
    
    private func createUI() {
        addSubview(stuffixBtn)
        stuffixBtn.isHidden = true
    }
    
    @objc private func didClickStuffixBtn() {
        
        updateSuffixBtnStatus(!isOpen)
        refreshLabel()
        btnActionDelegate?.flexibleViewDidFlex(view: self, isOpen: isOpen)
    }

}
