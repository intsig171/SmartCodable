//
//  UIDevice+iPhoneModel.swift
//  BTUIKit
//
//  Created by qxb171 on 2021/4/21.
//

import Foundation


public protocol iPhoneModelType {
    func iPhone() -> iPhoneModel
    static func iPhone() -> iPhoneModel
}

extension iPhoneModelType {
    public func iPhone() -> iPhoneModel {
        let model = getIPhoneModel()
        return model
    }

    static public func iPhone() -> iPhoneModel {
        let model = getIPhoneModel()
        return model
    }
}

///获取设备名称
fileprivate func getIPhoneModel() -> iPhoneModel {

    /**
     https://zh.wikipedia.org/wiki/IOS和iPadOS设备列表
     https://www.theiphonewiki.com/wiki/Models
     */

    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }

    switch identifier {
    ///iphone
    case "iPhone5,1", "iPhone5,2":              return .iPhone5
    case "iPhone5,3", "iPhone5,4":              return .iPhone5C
    case "iPhone6,1", "iPhone6,2":              return .iPhone5S

    case "iPhone7.2":                           return .iPhone6
    case "iPhone7,1":                           return .iPhone6Plus
    case "iPhone8,1":                           return .iPhone6s
    case "iPhone8,2":                           return .iPhone6Plus

    case "iPhone8,4":                           return .iPhoneSE1

    case "iPhone9,1","iPhone9,3":               return .iPhone7
    case "iPhone9,2","iPhone9,4":               return .iPhone7Plus

    case "iPhone10,1","iPhone10,4":             return .iPhone8
    case "iPhone10,2","iPhone10,5":             return .iPhone8Plus

    case "iPhone10,3","iPhone10,6":             return .iPhoneX
    case "iPhone11,8":                          return .iPhoneXR
    case "iPhone11,2":                          return .iPhoneXS
    case "iPhone11,6", "iPhone11,4":            return .iPhoneXSMax

    case "iPhone12,1":                          return .iPhone11
    case "iPhone12,3":                          return .iPhone11Pro
    case "iPhone12,5":                          return .iPhone11ProMax
    case "iPhone12,8":                          return .iPhoneSE2

    case "iPhone13,1":                          return .iPhone12Mini
    case "iPhone13,2":                          return .iPhone12
    case "iPhone13,3":                          return .iPhone12Pro
    case "iPhone13,4":                          return .iPhone12ProMax
        
    case "iPhone14,4":                          return .iPhone13Mini
    case "iPhone14,5":                          return .iPhone13
    case "iPhone14,2":                          return .iPhone13Pro
    case "iPhone14,3":                          return .iPhone13ProMax
        
    case "iPhone14,7":                          return .iPhone14
    case "iPhone14,8":                          return .iPhone14Plus
    case "iPhone15,2":                          return .iPhone14Pro
    case "iPhone15,3":                          return .iPhone14ProMax

    ///Simulator
    case "i386":                                return .simulator
    case "x86_64":                              return .simulator

    default:                                    return .unknown
    }
}


public enum iPhoneModel {
    
    // 2022年9月13日，新款iPhone 14、14 plus、14 Pro、14 Pro Max发布
    case iPhone14
    case iPhone14Plus
    case iPhone14Pro
    case iPhone14ProMax


    //2021年9月15日，新款iPhone 13 mini、13、13 Pro、13 Pro Max发布
    case iPhone13ProMax
    case iPhone13Pro
    case iPhone13
    case iPhone13Mini
    
    case iPhone12ProMax
    case iPhone12Pro
    case iPhone12
    case iPhone12Mini

    case iPhone11ProMax
    case iPhone11Pro
    case iPhone11

    case iPhoneXSMax
    case iPhoneXS
    case iPhoneXR
    case iPhoneX

    case iPhone8Plus
    case iPhone8

    case iPhone7Plus
    case iPhone7

    case iPhone6sPlus
    case iPhone6s
    case iPhone6Plus
    case iPhone6

    case iPhone5S
    case iPhone5C
    case iPhone5

    case iPhoneSE2  // 二代
    case iPhoneSE1 // 一代

    case simulator
    case unknown

    /// 获取手机型号名称 （iPhone 6 Plus）
    public func getModel() -> String {
        switch self {
        ///iphone
        case .iPhone5:
            return "iPhone 5"
        case .iPhone5C:
            return "iPhone 5C"
        case .iPhone5S:
            return "iPhone 5S"
        case .iPhone6:
            return "iPhone 6"
        case .iPhone6Plus:
            return "iPhone 6 Plus"
        case .iPhone6s:
            return "iPhone 6s"
        case .iPhone6sPlus:
            return "iPhone 6s Plus"
        case .iPhoneSE1:
            return "iPhone SE1"
        case .iPhone7:
            return "iPhone 7"
        case .iPhone7Plus:
            return "iPhone 7 Plus"
        case .iPhone8:
            return "iPhone 8"
        case .iPhone8Plus:
            return "iPhone 8 Plus"
        case .iPhoneX:
            return "iPhone X"
        case .iPhoneXR:
            return "iPhone XR"
        case .iPhoneXS:
            return "iPhone XS"
        case .iPhoneXSMax:
            return "iPhone XS Max"
        case .iPhone11:
            return "iPhone 11"
        case .iPhone11Pro:
            return "iPhone 11 Pro"
        case .iPhone11ProMax:
            return "iPhone 11 Pro Max"
        case .iPhoneSE2:
            return "iPhone SE2"
        case .iPhone12Mini:
            return "iPhone 12 mini"
        case .iPhone12:
            return "iPhone 12"
        case .iPhone12Pro:
            return "iPhone 12 Pro"
        case .iPhone12ProMax:
            return "iPhone 12 Pro Max"
            
        case .iPhone13Mini:
            return "iPhone 13 mini"
        case .iPhone13:
            return "iPhone 13"
        case .iPhone13Pro:
            return "iPhone 13 Pro"
        case .iPhone13ProMax:
            return "iPhone 13 Pro Max"
        case .simulator:
            return "Simulator"
        case .unknown:
            return "unknow"
        case .iPhone14:
            return "iPhone 14"
        case .iPhone14Plus:
            return "iPhone 14 Plus"
        case .iPhone14Pro:
            return "iPhone 14 Pro"
        case .iPhone14ProMax:
            return "iPhone 14 Pro Max"
        }
    }

    /// 物理分辨率
    public func physicalResolution() -> CGSize? {
        switch self {
        case .unknown, .simulator:
            return nil
        case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE1:
            return CGSize(width: 640, height: 1136)
        case .iPhone6, .iPhone6s, .iPhone7, .iPhone8, .iPhoneSE2:
            return CGSize(width: 750, height: 1334)
        case .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus:
            return CGSize(width: 1242, height: 2208)

        case .iPhoneX, .iPhoneXS, .iPhone11Pro:
            return CGSize(width: 1225, height: 2436)
        case .iPhoneXR, .iPhone11:
            return CGSize(width: 828, height: 1792)
        case .iPhoneXSMax, .iPhone11ProMax:
            return CGSize(width: 1242, height: 2688)

        case .iPhone12Mini, .iPhone13Mini:
            return CGSize(width: 1080, height: 2340)
        case .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro:
            return CGSize(width: 1170, height: 2532)
        case .iPhone12ProMax, .iPhone13ProMax:
            return CGSize(width: 1284, height: 2778)
        case .iPhone14:
            return CGSize(width: 1170, height: 2532)
        case .iPhone14Plus:
            return CGSize(width: 1284, height: 2778)
        case .iPhone14Pro:
            return CGSize(width: 1179, height: 2556)
        case .iPhone14ProMax:
            return CGSize(width: 1290, height: 2796)
        }
    }


    /// 缩放因子
    public func scaleFactor() -> CGFloat? {
        return UIScreen.main.scale
    }

    /// 逻辑分辨率
    public func logicalResolution() -> CGSize? {
        guard let size = physicalResolution() else {
            return nil
        }

        guard let scale = scaleFactor() else {
            return nil
        }

        let tempW = size.width / scale
        let tempH = size.height / scale

        return CGSize(width: tempW, height: tempH)
    }


    /// 对角尺寸(英寸)
    public func diagonalSize() -> CGFloat? {

        switch self {
        case .unknown, .simulator:
            return nil
        case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE1:
            return 4
        case .iPhone6, .iPhone6s, .iPhone7, .iPhone8, .iPhoneSE2:
            return 4.7
        case .iPhone12Mini, .iPhone13Mini:
            return 5.4
        case .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus:
            return 5.5
        case .iPhoneX, .iPhoneXS, .iPhone11Pro:
            return 5.8
        case .iPhoneXR, .iPhone11, .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro:
            return 6.1
        case .iPhoneXSMax, .iPhone11ProMax:
            return 6.5
        case .iPhone12ProMax, .iPhone13ProMax:
            return 6.7
        case .iPhone14:
            return 6.1
        case .iPhone14Plus:
            return 6.7
        case .iPhone14Pro:
            return 6.1
        case .iPhone14ProMax:
            return 6.7
        }
    }

    /// 芯片
    public func chip() -> String? {

        switch self {
        case .unknown, .simulator:
            return nil
        case .iPhone5, .iPhone5C:
            return "A6"
        case .iPhone5S:
            return "A7"
        case .iPhone6, .iPhone6Plus:
            return "A8"
        case .iPhoneSE1, .iPhone6s, .iPhone6sPlus:
            return "A9"
        case .iPhone7, .iPhone7Plus:
            return "A10"
        case .iPhone8, .iPhone8Plus, .iPhoneX:
            return "A11"
        case .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
            return "A12"
        case .iPhoneSE2, .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            return "A13"
        case .iPhone12Mini, .iPhone12, .iPhone12Pro, .iPhone12ProMax:
            return "A14"
        case .iPhone13Mini, .iPhone13, .iPhone13Pro, .iPhone13ProMax:
            return "A15"
        case .iPhone14, .iPhone14Plus:
            return "A15"
        case .iPhone14Pro, .iPhone14ProMax:
            return "A16"
        }
    }

    /// 是否全面屏
    public func isFullSreen() -> Bool {
        switch self {
        case .iPhone5, .iPhone5C, .iPhone5S:
            return false
        case .iPhone6, .iPhone6s, .iPhone6Plus, .iPhone6sPlus:
            return false
        case .iPhone7, .iPhone7Plus:
            return false
        case .iPhone8, .iPhone8Plus:
            return false
        case .iPhoneSE1, .iPhoneSE2:
            return false
        default:
            return true
        }
    }

    /// 是否iPhoneX之后发布的手机 (包含iPhoneX)
    public func isReleasedAtiPhoneX() -> Bool {
        switch self {
        case .iPhone5, .iPhone5C, .iPhone5S:
            return false
        case .iPhone6, .iPhone6s, .iPhone6Plus, .iPhone6sPlus:
            return false
        case .iPhone7, .iPhone7Plus:
            return false
        case .iPhone8, .iPhone8Plus:
            return false
        case .iPhoneSE1:
            return false
        default:
            return true
        }
    }
}









