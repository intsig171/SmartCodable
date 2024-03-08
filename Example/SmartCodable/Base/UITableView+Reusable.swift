//
//  UITableView+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/6/11.
//


import UIKit





public typealias UITableViewProtocol = UITableViewDelegate & UITableViewDataSource


extension UITableView {
    
    /// UITableView初始化方法
    /// - Parameters:
    ///   - cells: 要注册的Cell, 数组类型, 例如：[UITableViewCell.self]
    ///   - headers: 要注册的sectionHeaders,数组类型，例如：[UITableViewHeaderFooterView.self]
    ///   - footers: 要注册的sectionFooters,数组类型，例如：[UITableViewHeaderFooterView.self]
    ///   - delegate: 设置代理
    ///   - style: UITableView.Style，默认为plain
    public static func make <X: UITableView, T: UITableViewCell,U: UITableViewHeaderFooterView> (
        registerCells cells: [T.Type],
        registerHeaders headers: [U.Type]? = nil,
        registerFooters footers: [U.Type]? = nil,
        delegate: UITableViewProtocol,
        style: UITableView.Style = .plain) -> X {
        
        
        let tb = X.init(frame: .zero, style: style)
        tb.delegate = delegate
        tb.dataSource = delegate
        tb.separatorStyle = .none
        
        /// 关闭预估高度，防止存长图出现问题
        tb.estimatedRowHeight = 0
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        
        for item in cells {
            tb.registerCell(item)
        }
        
        if let temp = headers {
            for item in temp {
                tb.registerSectionHeader(item)
            }
        }
        
        if let temp = footers {
            for item in temp {
                tb.registerSectionFooter(item)
            }
        }
        
        return tb
    }
}



extension UITableView {
    
    /// 注册cell
    /// - Parameter type: 要注册的类型
    public func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let identifier = self.getClassName(type.classForCoder())
        register(type.self, forCellReuseIdentifier: identifier)
    }
    
    
    /// 注册sectionHeader
    /// - Parameter type: 要注册的类型
    public func registerSectionHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let identifier = self.getClassName(type.classForCoder())
        register(type.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    /// 注册sectionFooter
    /// - Parameter type: 要注册的类型
    public func registerSectionFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        let identifier = self.getClassName(type.classForCoder())
        register(type.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
}



extension UITableView {

    /// 获取cell，从复用池获取cell
    /// - Parameter indexPath: IndexPath
    public func makeCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        let identifier = self.getClassName(T.classForCoder())
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return T()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    /// 获取复用的 SectionHeader
    public func makeSectionHeader<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        let identifier = getClassName(T.classForCoder())
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: identifier)  as? T else { return T() }
        return header
    }
    
    /// 获取复用的 SectionFooter
    public func makeSectionFooter<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        let identifier = getClassName(T.classForCoder())
        guard let footer = dequeueReusableHeaderFooterView(withIdentifier: identifier)  as? T else { return T() }
        return footer
    }
    
}


extension UITableView {

    fileprivate func getClassName(_ obj:Any) -> String {
        let mirro = Mirror(reflecting: obj)
        let className = String(describing: mirro.subjectType).components(separatedBy: ".").first ?? ""
        return className
    }
}



