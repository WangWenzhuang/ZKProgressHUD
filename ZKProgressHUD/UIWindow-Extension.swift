//
//  UIWindow-Extension.swift
//  Demo
//
//  Created by 王文壮 on 2019/3/25.
//  Copyright © 2019 WangWenzhuang. All rights reserved.
//

import UIKit

extension UIWindow {
    static var frontWindow: UIWindow? {
        get {
            let window = UIApplication.shared.windows.reversed().first(where: {
                $0.screen == UIScreen.main &&
                    !$0.isHidden && $0.alpha > 0 &&
                    $0.windowLevel == UIWindow.Level.normal
            })
            return window
        }
    }
    /// 获取当前活动的控制器
    static var visibleViewController: UIViewController? {
        return UIWindow.visibleViewControllerFrom(UIWindow.frontWindow?.rootViewController)
    }
    
    private static func visibleViewControllerFrom(_ viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return UIWindow.visibleViewControllerFrom(navigationController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return UIWindow.visibleViewControllerFrom(tabBarController.selectedViewController)
        } else {
            if let presentedViewController = viewController?.presentedViewController {
                return UIWindow.visibleViewControllerFrom(presentedViewController)
            } else {
                return viewController
            }
        }
    }
}
