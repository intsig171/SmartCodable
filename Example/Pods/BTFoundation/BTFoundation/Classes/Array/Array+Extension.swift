//
//  Array+Extension.swift
//  BTFoundation
//
//  Created by Mccc on 2020/4/7.
//

import Foundation
import BTNameSpace



/// 数组的截取
extension Array {
    /// 从头截取到指定位置
    /// 字符串的截取 从头截取到指定index
    public func bt_clipFromPrefix(to index: Int) -> [Element] {
        let end = Array(prefix(index))
        return end
    }

    /// 字符串的截取 从指定位置截取到尾部
    public func bt_clipToSuffix(from index: Int) -> [Element] {
        let end = Array(suffix(index))
        return end
    }
}


extension Array {
    /// 数组转json字符串
    public func bt_toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let json = String(data: data, encoding: String.Encoding.utf8)
            return json
        } catch {
            return nil
        }
    }
}

extension Array {
    /// 删除数组中的多个下标对应的元素项
    /// - Parameter indexes: 下标集合，做了越界的处理
    public mutating func bt_remove(at indexes: [Int]) {
        var lastIndex: Int? = nil
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            if index < count {
                remove(at: index)
                lastIndex = index
            }
        }
    }
}

extension Array {
    /// 从数组中返回一个随机元素
    public var bt_random: Element? {
        //如果数组为空，则返回nil
        guard count > 0 else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
     
    /// 从数组中从返回指定个数的元素
    ///
    /// - Parameters:
    ///   - count: 希望返回的元素个数
    ///   - allowRepeat: 返回的元素是否不可以重复（默认为false，可以重复）
    public func bt_random(count: Int, allowRepeat: Bool = false) -> [Element]? {
        //如果数组为空，则返回nil
        guard !isEmpty else { return nil }
         
        var sampleElements: [Element] = []
         
        //返回的元素可以重复的情况
        if allowRepeat {
            for _ in 0..<count {
                if let temp = bt_random {
                    sampleElements.append(temp)
                }
            }
        }
        //返回的元素不可以重复的情况
        else{
            //先复制一个新数组
            var copy = self.map { $0 }
            for _ in 0..<count {
                //当元素不能重复时，最多只能返回原数组个数的元素
                if copy.isEmpty { break }
                let randomIndex = Int(arc4random_uniform(UInt32(copy.count)))
                let element = copy[randomIndex]
                sampleElements.append(element)
                //每取出一个元素则将其从复制出来的新数组中移除
                copy.remove(at: randomIndex)
            }
        }
        return sampleElements
    }
}


extension Array {
    
    /// 数组内中文按拼音字母排序
    ///
    /// - Parameter ascending: 是否升序（默认升序）
    /// - Parameter ascending: 是否区分大小写（默认区分） - 区分统一转为大写处理
    func sortedByPinyin(ascending: Bool = true, upperorLower:Bool = true) -> Array? {
        if count == 0 {
            return nil
        }
        
        return sorted { (value1, value2) -> Bool in
            var pinyin1 = value1 as? String ?? ""
            pinyin1 = pinyin1.bt.transformToPinyin()
            
            var pinyin2 = value2 as? String ?? ""
            pinyin2 = pinyin2.bt.transformToPinyin()
            
            pinyin1 = pinyin1.uppercased()
            pinyin2 = pinyin2.uppercased()
            return pinyin1.compare(pinyin2) == (ascending ? .orderedAscending : .orderedDescending)
        }
    }
}




