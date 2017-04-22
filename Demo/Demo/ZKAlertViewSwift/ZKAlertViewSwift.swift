//
//  ZKAlertViewSwift.swift
//  ZKAlertViewDemo
//
//  Created by 王文壮 on 16/8/4.
//  Copyright © 2016年 ZKTeam. All rights reserved.
//

import UIKit

public typealias ZKClickAtIndexBlock = (_ alertView : UIAlertView, _ buttonIndex : Int) -> Void

open class ZKAlertViewSwift: NSObject {
    internal static let object = ZKAlertViewSwiftObject()
    
    open static func showAlertView(_ title : String, message : String, buttonTitle : String) {
        ZKAlertViewSwift.showAlertView(title, message: message, buttonTitle: buttonTitle, clickAtIndexBlock: nil)
    }
    
    open static func showAlertView(_ title : String, message : String, buttonTitle : String, clickAtIndexBlock : ZKClickAtIndexBlock!) {
        ZKAlertViewSwift.showAlertView(title, message: message, clickAtIndexBlock: clickAtIndexBlock, cancleButtonTitle: buttonTitle, otherButtonTitles: nil)
    }
    
    open static func showAlertView(_ title : String, message : String, clickAtIndexBlock : ZKClickAtIndexBlock!, cancleButtonTitle : String, otherButtonTitles : String!...) {
        if clickAtIndexBlock != nil {
            ZKAlertViewSwift.object.ClickAtIndexBlock = clickAtIndexBlock
        }
        let alertView = UIAlertView.init(title: title, message: message, delegate: ZKAlertViewSwift.object, cancelButtonTitle: cancleButtonTitle)
        for buttonTitle in otherButtonTitles {
            if buttonTitle == nil {
                break
            }
            alertView.addButton(withTitle: buttonTitle)
        }
        alertView.show()
    }
}
