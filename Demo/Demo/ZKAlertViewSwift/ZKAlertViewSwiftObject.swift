//
//  ZKAlertViewSwiftObject.swift
//  ZKAlertViewSwiftDemo
//
//  Created by 王文壮 on 16/8/4.
//  Copyright © 2016年 ZKTeam. All rights reserved.
//
import UIKit

class ZKAlertViewSwiftObject: NSObject, UIAlertViewDelegate {
    var ClickAtIndexBlock : ZKClickAtIndexBlock?
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if ZKAlertViewSwift.object.ClickAtIndexBlock !=  nil {
            ZKAlertViewSwift.object.ClickAtIndexBlock!(alertView, buttonIndex)
        }
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        ZKAlertViewSwift.object.ClickAtIndexBlock = nil
    }
}
