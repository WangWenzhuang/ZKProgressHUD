//
//  ZKProgressGifView.swift
//  Demo
//
//  Created by 王文壮 on 2017/3/15.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit
import ImageIO

class ZKGifView: UIView {

    var width:CGFloat{return self.frame.size.width}
    var height:CGFloat{return self.frame.size.height}
    private var gifurl:NSURL! // 把本地图片转化成URL
    private var images:Array<CGImage> = [] // 图片数组(存放每一帧的图片)
    private var delays:Array<NSNumber> = [] // 时间数组(存放每一帧的图片的时间)
    private var totalDelay:Float = 0 // gif动画时间
    /**
     *  加载本地GIF图片
     */
    func showGIFImageWithLocalName(name:String) {
        gifurl = Bundle.main.url(forResource: name, withExtension: "gif") as NSURL!
        self.creatKeyFrame()
    }
    
    
    /**
     *  获取GIF图片的每一帧 有关的东西  比如：每一帧的图片、每一帧的图片执行的时间
     */
    private func creatKeyFrame() {
        
        guard let source = CGImageSourceCreateWithURL(gifurl as CFURL, nil) else {
            return
        }

        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as NSDictionary!
            let gifProperties = cfProperties?[String(kCGImagePropertyGIFDictionary)] as! NSDictionary!
            let delay = gifProperties![String(kCGImagePropertyGIFUnclampedDelayTime)] as! NSNumber
            delays.append(delay)
            totalDelay += delay.floatValue
            
            // 获取图片的尺寸 (适应)
            let imageWitdh = cfProperties?[String(kCGImagePropertyPixelWidth)] as! NSNumber
            let imageHeight = cfProperties?[String(kCGImagePropertyPixelHeight)] as! NSNumber
            if imageWitdh.floatValue / imageHeight.floatValue != Float(width / height) {
                self.fitScale(imageWitdh: CGFloat(imageWitdh.floatValue), imageHeight: CGFloat(imageHeight.floatValue))
            }
        }
        
        self.showAnimation()
    }
    
    private func fitScale(imageWitdh: CGFloat, imageHeight: CGFloat) {
        var newWidth:CGFloat
        var newHeight:CGFloat
        if imageWitdh/imageHeight > width/height {
            newWidth = width
            newHeight = width / (imageWitdh / imageHeight)
        } else {
            newWidth = height / (imageHeight / imageWitdh)
            newHeight = height
        }
        let point = self.center
        self.frame.size = CGSize(width: newWidth, height: newHeight)
        self.center = point
    }
    
    private func showAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "contents")
        var current:Float = 0
        var timeKeys:Array<NSNumber> = []
        
        for delay in self.delays {
            timeKeys.append(NSNumber(value: current / self.totalDelay))
            current += delay.floatValue
        }
        animation.keyTimes = timeKeys
        animation.values = images
        animation.repeatCount = HUGE
        animation.duration = TimeInterval(totalDelay)
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "MGGifView")
    }

}
