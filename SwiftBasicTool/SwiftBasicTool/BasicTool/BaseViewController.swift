//
//  BaseViewController.swift
//  SwiftBasicTool
//
//  Created by Stephen.Zeng on 2022/2/10.
//

import UIKit

public enum StatusBarStyle {
    case hidden
    case black
    case white
}

open class BaseViewController: UIViewController {
    
    public var isPresenting: Bool {
        guard let loaded = viewIfLoaded, let window = loaded.window else {
            return false
        }
        return window == UIApplication.shared.kWindow
    }
    
    public var statusBarStyle: StatusBarStyle = .white {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        switch statusBarStyle {
        case .black:
            return .default
        case .white, .hidden:
            return .lightContent
        }
    }
    
    open override var prefersStatusBarHidden: Bool {
        switch statusBarStyle {
        case .white, .black:
            return false
        default:
            return true
        }
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
}
