//
//  UIImage+Extension.swift
//  BTNameSpace
//
//  Created by Mccc on 2020/4/15.
//

import Foundation
import UIKit
import BTNameSpace


extension UIImage: NamespaceWrappable { }


/// 常用功能
extension NamespaceWrapper where T == UIImage {
    
    
    /// 加载图片资源（从Images.xcassets加载图片）
    /// - Parameters:
    ///   - name: 图片名称
    ///   - bundle: 图片所在的bundle
    /// - Returns: UIImage?
    public static func loadImage(_ name: String, inBundle bundle: Bundle?) -> UIImage? {
        if #available(iOS 13, *) {
            let image = UIImage.init(named: name, in: bundle, with: nil)
            return image
        } else {
            
            let image = UIImage.init(named: name, in: bundle, compatibleWith: nil)
            return image
        }
    }

    
    

    /// 更改图片颜色 统一渲染为一个纯色。透明区域不会被渲染
    /// - Parameter color: 要渲染成的颜色
    public func render(by color: UIColor) -> UIImage? {
        let width: CGFloat = wrappedValue.size.width
        let height: CGFloat = wrappedValue.size.height
        let drawRect = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(wrappedValue.size, false, wrappedValue.scale)
        color.setFill()
        UIRectFill(drawRect)
        wrappedValue.draw(in: drawRect, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    
    
    /// 旋转图片
    /// - Parameter orientation: 旋转的倾向 https://www.jianshu.com/p/1c6a8c16baca
    ///     - up            默认方向
    ///     - left          逆时针旋转90°
    ///     - right         顺时针旋转90°
    ///     - down          180°旋转
    ///     - upMirrored    水平镜像/左右镜像 (前后两个图左右对称)
    ///     - downMirrored  垂直镜像/上下镜像（前后两个图上下对称）
    ///     - leftMirrored  逆时针旋转90度后，上下镜像
    ///     - rightMirrored 顺时针旋转90度后，上下镜像
    /// - Returns: 生成的图片对象
    /// - Returns: 旋转之后的图片
    public func rotating(_ orientation: UIImage.Orientation) -> UIImage? {
        if let cgImage = wrappedValue.cgImage {
            let tempImage = UIImage.init(cgImage: cgImage, scale: wrappedValue.scale, orientation: orientation)
            // 缓存对象
            return tempImage
        }
        return nil
    }
    
    
    /// 对图片的大小进行缩放
    /// - Parameter ratio: 缩放比例
    /// - Returns: 缩放之后的图片
    public func zoom(_ ratio: CGFloat) -> UIImage? {
        if ratio < 0.3 { return wrappedValue }
        if ratio > 3 { return wrappedValue }
        if ratio == 1 { return wrappedValue }
        let newWidth = wrappedValue.size.width*ratio
        let newHeight = wrappedValue.size.height*ratio
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let img = resize(newSize: newSize)
        return img
    }
    

    /// 重设图片的size
    /// - Parameter newSize: 新的图片尺寸
    public func resize(newSize: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        wrappedValue.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}


//MARK: 图片裁切，压缩等操作
extension NamespaceWrapper where T == UIImage {
    
    //二分压缩法
    public func compressImageMid(maxLength: Int) -> Data? {
       var compression: CGFloat = 1
        guard var data = wrappedValue.jpegData(compressionQuality: 1) else { return nil }
       print( "压缩前kb: \( Double((data.count)/1024))")
       if data.count < maxLength {
           return data
       }
       print("压缩前kb\(data.count / 1024)KB")
       var max: CGFloat = 1
       var min: CGFloat = 0
       for _ in 0..<6 {
           compression = (max + min) / 2
        data = wrappedValue.jpegData(compressionQuality: compression)!
           if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
               min = compression
           } else if data.count > maxLength {
               max = compression
           } else {
               break
           }
       }
       if data.count < maxLength {
           return data
       }
        return nil
    }
    
    
    /// 压缩上传图片到指定字节
    /// - Parameter length: 最大字节数 (比如要压缩到64k，需要传64*1024)
    public func compress(to length: Int) -> Data? {
        
        let newSize = self.zoomByMaxSide(300)
        
        if let newImage = self.resize(newSize: newSize) {
            var compress:CGFloat = 0.9
            if var data = newImage.jpegData(compressionQuality: compress) {
                while data.count > length && compress > 0.01 {
                    compress -= 0.02
                    data = newImage.jpegData(compressionQuality: compress)!
                }
                return data
            }
        }
         return nil
    }
    
    
    private func isByteSize(ofData data: Data, lessThenMB size: Int) -> Bool {
        let mbSize = Int64(size * 1000000)
        return data.count < mbSize
    }
    
    /// 压缩上传图片到指定大小
    /// - Parameter maxSizeMB: 最大兆数MB
    /// - Parameter maxRepeatCount: 最大压缩循环次数，必须小于9次
    public func convert(maxSizeMB size: Int, maxRepeatCount count: Int = 7) -> Data? {
        var compressionQuality: CGFloat = 1.0
        var mutableData = Data()
        var tempCount: Int = 0
        repeat {
            tempCount += 1
            if tempCount > count {
                // 压缩大于10次后，压缩图片质量方法不生效，产生死循环，所以限定压缩次数
                return nil
            }
            guard let imageData = wrappedValue.jpegData(compressionQuality: compressionQuality) else {
                return nil
            }
            compressionQuality -= 0.1
            mutableData = imageData
            
        } while !isByteSize(ofData: mutableData, lessThenMB: size)
        
        
        if mutableData.count == 0 {
            return nil
        }
        
        return mutableData
    }
    

    
    
    /// 通过指定图片最长边，获得等比例的图片size 和resize方法结合使用
    /// - Parameter maxSide: 图片允许的最长宽度（高度）
    public func zoomByMaxSide(_ maxSide: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = wrappedValue.size.width
        var newHeight:CGFloat = wrappedValue.size.height
        
        let width = wrappedValue.size.width
        let height = wrappedValue.size.height
        
        if (width > maxSide || height > maxSide){
            
            if (width > height) {
                newWidth = maxSide;
                newHeight = newWidth * height / width;
            }else if(height > width){
                newHeight = maxSide;
                newWidth = newHeight * width / height;
            }else{
                newWidth = maxSide;
                newHeight = maxSide;
            }
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    

    /// 裁切指定区域（CGRect）获取图片
    /// - Parameter rect: 裁切范围
    public func cropByRect(_ rect:CGRect) -> UIImage? {
        
        if let imageRef = wrappedValue.cgImage?.cropping(to: rect) {
            let image = UIImage.init(cgImage: imageRef, scale: wrappedValue.scale, orientation: wrappedValue.imageOrientation)
            return image
        }
        return nil
    }
    
}


//MARK: 创建图片
extension NamespaceWrapper where T == UIImage {
    

    
    
    
    /// 修复图片旋转
    public func repairOrientation() -> UIImage? {
        if wrappedValue.imageOrientation == .up {
            return wrappedValue
        }
        var transform = CGAffineTransform.identity
        switch wrappedValue.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: wrappedValue.size.width, y: wrappedValue.size.height)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: wrappedValue.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: wrappedValue.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        default:
            break
        }
        switch wrappedValue.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: wrappedValue.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: wrappedValue.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        
        if let tempCGImage = wrappedValue.cgImage {
            let ctx = CGContext(data: nil, width: Int(wrappedValue.size.width), height: Int(wrappedValue.size.height), bitsPerComponent: tempCGImage.bitsPerComponent, bytesPerRow: 0, space: tempCGImage.colorSpace!, bitmapInfo: tempCGImage.bitmapInfo.rawValue)
            ctx?.concatenate(transform)
            switch wrappedValue.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx?.draw(wrappedValue.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(wrappedValue.size.height), height: CGFloat(wrappedValue.size.width)))
                break
            default:
                ctx?.draw(wrappedValue.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(wrappedValue.size.width), height: CGFloat(wrappedValue.size.height)))
                break
            }
            if let cgimg: CGImage = (ctx?.makeImage()) {
                let img = UIImage(cgImage: cgimg)
                return img
            }
        }
        
        return nil
    }
}







