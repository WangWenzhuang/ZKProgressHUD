//
//  ZKProgressView.swift
//  ZKProgressHUD
//
//  Created by 王文壮 on 2017/3/15.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

// MARK: - 进度
class ZKProgressView: UIView {
    var progressColor: UIColor?
    private var _progress: Double = 0
    var progress: Double {
        get {
            return _progress
        }
        set {
            self._progress = newValue
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let arcCenter = CGPoint(x: self.width / 2, y: self.width / 2)
        let radius = arcCenter.x - 2
        let startAngle = -(Double.pi / 2)
        let endAngle = startAngle + Double.pi * 2 * self.progress
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        ctx!.setLineWidth(4)
        self.progressColor?.setStroke()
        ctx!.addPath(path.cgPath)
        ctx!.strokePath()
    }
}
