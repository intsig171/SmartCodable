//
//  UICollectionView+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/6/11.
//


import UIKit
import BTNameSpace

public typealias UICollectionViewProtocol = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout


public protocol UICollectionViewNamespaceWrappable: NamespaceWrappable { }

extension UICollectionView: UICollectionViewNamespaceWrappable { }

extension NamespaceWrapper where T == UICollectionView {

    
    /// UICollectionView初始化方法
    /// - Parameters:
    ///   - cells: 要注册的Cell, 数组类型, 例如：[UITableViewCell.self]
    ///   - headers: 要注册的sectionHeaders,数组类型，例如：[UICollectionReusableView.self]
    ///   - footers: 要注册的sectionFooters,数组类型，例如：[UICollectionReusableView.self]
    ///   - delegate: 设置代理
    ///   - layout: UICollectionViewFlowLayout
    public static func make<T: UICollectionViewCell, U: UICollectionReusableView> (
        registerCells cells: [T.Type],
        registerHeaders headers: [U.Type]? = nil,
        registerFooters footers: [U.Type]? = nil,
        delegate: UICollectionViewProtocol,
        layout: UICollectionViewFlowLayout
        ) -> UICollectionView {
        
        
        let co = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        co.delegate = delegate
        co.dataSource = delegate
        co.backgroundColor = UIColor.white
        
        
        for item in cells {
            co.bt.registerCell(item)
        }
        
        if let temp = headers {
            for item in temp {
                co.bt.registerSectionHeader(item)
            }
        }
        
        if let temp = footers {
            for item in temp {
                co.bt.registerSectionFooter(item)
            }
        }
        
        return co
    }
}



extension NamespaceWrapper where T: UICollectionView {
    /// 提前注册cell
    public func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        let identifier = self.getClassName(type.classForCoder())
        wrappedValue.register(type.self, forCellWithReuseIdentifier: identifier)
    }
    
    /// 提前注册SectionHeader
    public func registerSectionHeader<T: UICollectionReusableView>(_ type: T.Type) {
        let identifier = self.getClassName(type.classForCoder())
        wrappedValue.register(type.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    /// 提前注册SectionFooter
    public func registerSectionFooter<T: UICollectionReusableView>(_ type: T.Type) {
        let identifier = self.getClassName(type.classForCoder())
        wrappedValue.register(type.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
}


extension NamespaceWrapper where T: UICollectionView {

    /// 获取复用的cell
    public func makeCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        let identifier = self.getClassName(T.classForCoder())
        guard let cell = wrappedValue.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            return T()
        }
        
        return cell
    }
    
    /// 获取复用的 SectionHeader
    public func makeSectionHeader<T: UICollectionReusableView>(indexPath: IndexPath) -> T {
        let identifier = getClassName(T.classForCoder())
        
        guard let header = wrappedValue.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as? T else { return T() }
        return header
    }
    
    
    /// 获取复用的 SectionFooter
    public func makeSectionFooter<T: UICollectionReusableView>(indexPath: IndexPath) -> T {
        let identifier = getClassName(T.classForCoder())
        guard let header = wrappedValue.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as? T else { return T() }
        return header
    }

}


extension NamespaceWrapper where T: UICollectionView {
    
    fileprivate func getClassName(_ obj:Any) -> String {
        let mirro = Mirror(reflecting: obj)
        if let className = String(describing: mirro.subjectType).components(separatedBy: ".").first {
            return className
        }
        
        return ""
    }
}

