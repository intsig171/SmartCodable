//
//  BTTextView.swift
//  BTFoundation
//
//  Created by Mccc on 2020/6/4.
//

import Foundation
import SnapKit
import BTFoundation


public enum BTReturnKeyType {
    case done      // 完成按钮，点击收起键盘
    case newline   // 换行按钮，点击换行处理
}


@objc public protocol BTTextViewDelegate: NSObjectProtocol {
    @objc optional func textViewDidChange(_ textView: BTTextView)
    @objc optional func textViewShouldBeginEditing(_ textView: BTTextView)
    @objc optional func textViewDidEndEditing(_ textView: BTTextView)
    @objc optional func textView(_ textView: BTTextView, dynamicUpdateHeight height: CGFloat)
}


public class BTTextView: UIView {
    
    public weak var delegate: BTTextViewDelegate?
    

    /// 限制文本的设置（限制数量，颜色，字体，间距）
    public var limit: LimitText = LimitText() {
        didSet {
            limitCountLabel.text = limitLabelText(count: 0)
            
            if limit.count > 0 {
                limitCountLabel.isHidden = false
            } else {
                limitCountLabel.isHidden = true
            }
            
            limitCountLabel.textColor = limit.color
            limitCountLabel.font = limit.font
        }
    }

    /// 占位内容的设置（占位内容，文字颜色，字体跟随TextView）
    public var placeholder = PlaceHolder() {
        didSet {
            placeholderLabel.text = placeholder.text
            placeholderLabel.textColor = placeholder.color
            placeholderLabel.textContainerInset = placeholder.textContainerInset
        }
    }
    
    /// 字体的设置（会同时设置文本内容和placeholder的字体）
    public var font = UIFont.defaultFont {
        didSet {
            editView.font = font
            placeholderLabel.font = font
        }
    }
    
    public var dynamicHeight = DynamicHeight() {
        didSet {
            if dynamicHeight.isSupport {
                editView.layoutManager.allowsNonContiguousLayout = false
            }
        }
    }
    
    /// 键盘上return键的设置（换行 或者 确定）
    public var returnKeyboardType: BTReturnKeyType = .newline {
        didSet {
            if returnKeyboardType == .done {
                editView.returnKeyType = .done
            } else {
                editView.returnKeyType = .default
            }
        }
    }
    
    public func reloadData() {
        update(attributeString: editView.attributedText)
        if dynamicHeight.isSupport {
            dynamicUpdateHeight()
        }
    }
    
    private var isFirstUpdate: Bool = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: 懒加载
    private lazy var placeholderLabel: UITextView = {
        let label = UITextView()
        label.text = "请输入"
        label.backgroundColor = UIColor.clear
        label.font = UIFont.defaultFont
        label.textColor = UIColor.placeholderColor
        label.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return label
    }()
    
    public lazy var editView: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.font = UIFont.defaultFont
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var limitCountLabel: UILabel = {
        let label = UILabel()
        label.text = limitLabelText(count: 0)
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = limit.color
        label.textAlignment = NSTextAlignment.right
        return label
    }()
}

extension BTTextView {
    func initUI() {
        self.addSubview(limitCountLabel)
        self.addSubview(placeholderLabel)
        self.addSubview(editView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let limitHeight = limit.margin.top + limit.margin.bottom + 14

        if isFirstUpdate {
            let tempMin = frame.size.height - limitHeight
            dynamicHeight.min = min(dynamicHeight.min, tempMin)
            dynamicHeight.max = dynamicHeight.max - limitHeight
            isFirstUpdate = false
        }

        
        limitCountLabel.snp.remakeConstraints {
            $0.right.equalTo(-limit.margin.right)
            $0.bottom.equalTo(-limit.margin.bottom)
            $0.height.equalTo(14)
        }
        
        placeholderLabel.snp.remakeConstraints {
            $0.top.equalTo(self)
            $0.left.equalTo(self)
            $0.right.equalTo(self)
            $0.bottom.equalTo(-limitHeight)
        }

        editView.snp.remakeConstraints {
            $0.edges.equalTo(placeholderLabel)
        }
    }
}

extension BTTextView {
    func limitLabelText(count: Int) -> String {
        return "\(count) / \(limit.count)"
    }
    
    /// 根据文本内容，动态计算高度。并通过代理方法回调出去高度。
    func dynamicUpdateHeight() {
        
        /// 如果不支持动态高度，就不处理
        if !dynamicHeight.isSupport {
            return
        }
        
        /// 14是字数栏显示的高度
        let limitHeight = limit.margin.top + limit.margin.bottom + 14

        if editView.frame == .zero {
            layoutIfNeeded()
        }
        
        editView.isScrollEnabled = true
        var sizeHeight: CGFloat = editView.contentSize.height
        
        //如果textview的高度大于最大高度高度就为最大高度并可以滚动，否则不能滚动
        if sizeHeight >= dynamicHeight.max {
            sizeHeight = dynamicHeight.max
        }else{
            if sizeHeight < dynamicHeight.min {
                sizeHeight = dynamicHeight.min
            }
        }
        
        self.delegate?.textView?(self, dynamicUpdateHeight: sizeHeight + limitHeight)
    }

    /// 更新所有参数
    func update(attributeString: NSAttributedString) {
        
        var attString = attributeString
        if limit.count > 0 && attributeString.string.count > limit.count{
            attString = attributeString.attributedSubstring(from: NSRange(location: 0, length: limit.count))
        }
        editView.attributedText = attString
        dynamicUpdateHeight()
        updateCount(attributeString: attString)
    }
    
    /// 更新count
    func updateCount(attributeString: NSAttributedString) {
        if attributeString.string.isEmpty {
            placeholderLabel.isHidden = false
            limitCountLabel.text = limitLabelText(count: 0)
        } else {
            placeholderLabel.isHidden = true
            limitCountLabel.text = limitLabelText(count: attributeString.string.count)
        }
    }
}

extension BTTextView : UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        
        let language = textView.textInputMode?.primaryLanguage
        //记录光标位置
        let loc = textView.selectedRange.location
        if let lan = language,lan.elementsEqual("zh-Hans"),let selectedRange = textView.markedTextRange,let _ = textView.position(from: (selectedRange.start), offset: 0) {
            return
        } else {
            if let currentAttring = textView.attributedText {
                update(attributeString: currentAttring)
            }
        }
        
        self.limitCountLabel.text = limitLabelText(count: textView.text.count)
        delegate?.textViewDidChange?(self)
        
        if dynamicHeight.isSupport {
            dynamicUpdateHeight()
        }
        textView.selectedRange = NSRange(location: loc, length: 0)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        updateCount(attributeString: textView.attributedText)
        delegate?.textViewShouldBeginEditing?(self)
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.isEmpty ? false : true
        delegate?.textViewDidEndEditing?(self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count <= range.length, text.isEmpty {
            placeholderLabel.isHidden = false
        }else{
            placeholderLabel.isHidden = true
        }
        
        if returnKeyboardType == .done {
            if text == "\n" {
                textView.resignFirstResponder()
            }
            return true
        }
        return true
    }
}
