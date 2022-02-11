//
//  BaseNavigationViewController.swift
//  SwiftBasicTool
//
//  Created by Stephen.Zeng on 2022/2/10.
//

import UIKit

public class BaseNavigationViewController: UINavigationController {
    
    open var navigationBarHeight: CGFloat = 44
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if navigationBar.frame.minY <= 0 {
            
        }
//        if (self.navigationBar.frameMinY < 1) {
//                self.navigationBar.frameHeight = 64;
//            } else {
//                self.navigationBar.frameHeight = 44;
//            }
    }

}
