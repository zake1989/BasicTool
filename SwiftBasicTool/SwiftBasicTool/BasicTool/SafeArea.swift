//
//  SafeArea.swift
//  Beacon
//
//  Created by zeng on 2021/6/1.
//  Copyright © 2021 Beacon. All rights reserved.
//

import UIKit

public struct SafeArea {
    
    private static let shared = SafeArea()
    
    private let windowFrame: CGRect
    private let safeAreaInsets: UIEdgeInsets
    private let navigationBarFrame: CGRect
    private let tabBarFrame: CGRect
    

    private init() {
        let window = UIApplication.shared.kWindow
        self.windowFrame = window?.frame ?? .zero
        self.safeAreaInsets = window?.safeAreaInsets ?? .zero
        
        self.navigationBarFrame = UINavigationController().navigationBar.frame
        self.tabBarFrame = UITabBarController().tabBar.frame
    }
    
    public static var top: CGFloat = {
        return shared.safeAreaInsets.top
     }()
    
    public static var bottom: CGFloat = {
        return shared.safeAreaInsets.bottom
    }()
    
    public static var scale: CGFloat = {
        return UIScreen.main.scale
    }()
    
    public static var screenWidth: CGFloat = {
        return shared.windowFrame.width
    }()
    
    public static var screenHeight: CGFloat = {
        return shared.windowFrame.height
    }()
    
    public static var screenBounds: CGRect = {
        return shared.windowFrame
    }()
    
    public static var navigationBarBottom: CGFloat {
        return shared.navigationBarFrame.height + top
    }
    
    public static var tabBarHeigh: CGFloat{
        return shared.tabBarFrame.height + bottom
    }
    
    public static var isSamllDevice: Bool{
        return shared.windowFrame.width <= 320
    }
    
    public static var isBigDevice: Bool{
        return shared.windowFrame.width > 375
    }
}


