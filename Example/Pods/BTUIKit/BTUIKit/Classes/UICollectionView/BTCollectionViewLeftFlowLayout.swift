//
//  BTCollectionViewLeftFlowLayout.swift
//  BTFoundation
//
//  Created by Mccc on 2020/6/12.
//

import Foundation


/// 居左Cell样式
open class BTCollectionViewLeftFlowLayout: UICollectionViewFlowLayout {
    private var sumCellWidth: CGFloat = 0.0

    override public init() {
        super.init()
        scrollDirection = UICollectionView.ScrollDirection.vertical
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes_super = super.layoutAttributesForElements(in: rect) ?? [UICollectionViewLayoutAttributes]()
        let layoutAttributes:[UICollectionViewLayoutAttributes] = NSArray(array: layoutAttributes_super, copyItems: true) as! [UICollectionViewLayoutAttributes]
        var layoutAttributes_t = [UICollectionViewLayoutAttributes]()
        for index in 0..<layoutAttributes.count {
            let currentAttr = layoutAttributes[index]
            let previousAttr = index == 0 ? nil : layoutAttributes[index - 1]
            let nextAttr = index + 1 == layoutAttributes.count ? nil : layoutAttributes[index + 1]
            
            layoutAttributes_t.append(currentAttr)
            sumCellWidth += currentAttr.frame.size.width
            
            let previousY: CGFloat = previousAttr == nil ? 0 : previousAttr!.frame.maxY
            let currentY: CGFloat = currentAttr.frame.maxY
            let nextY: CGFloat = nextAttr == nil ? 0 : nextAttr!.frame.maxY
            
            if currentY != previousY, currentY != nextY {
                if currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader {
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                } else if currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter {
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                } else {
                    setCellFrame(with: layoutAttributes_t)
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                }
            } else if currentY != nextY {
                self.setCellFrame(with: layoutAttributes_t)
                layoutAttributes_t.removeAll()
                sumCellWidth = 0.0
            }
        }
        return layoutAttributes
    }
    
    func setCellFrame(with layoutAttributes: [UICollectionViewLayoutAttributes]) {
        var nowWidth: CGFloat = self.sectionInset.left
        for attributes in layoutAttributes{
            var nowFrame = attributes.frame
            nowFrame.origin.x = nowWidth
            attributes.frame = nowFrame
            
            nowWidth = nowWidth + nowFrame.size.width + minimumInteritemSpacing
        }
    }
}


