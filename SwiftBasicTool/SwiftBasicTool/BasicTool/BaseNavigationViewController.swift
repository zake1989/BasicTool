//
//  BaseNavigationViewController.swift
//  SwiftBasicTool
//
//  Created by Stephen.Zeng on 2022/2/10.
//

import UIKit

public class BaseNavigationViewController: UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

}
