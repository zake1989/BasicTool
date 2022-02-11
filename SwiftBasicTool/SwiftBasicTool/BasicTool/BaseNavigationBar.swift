//
//  BaseNavigationBar.swift
//  SwiftBasicTool
//
//  Created by Stephen.Zeng on 2022/2/11.
//

import UIKit

open class BaseNavigationBar: UINavigationBar {
    private var barHeight: CGFloat = 44
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: barHeight)
    }

    // MARK: Overrides
    open override func layoutSubviews() {
        super.layoutSubviews()

        guard #available(iOS 11.0, *) else {
            return
        }
        
        let topGuide = SafeArea.top
        let fullHeight = topGuide + barHeight
        
        var frameY: CGFloat = frame.minY
        var barY: CGFloat = 0.0
        if frameY != 0 {
            frameY = -topGuide
        } else {
            barY = topGuide
        }
        
        let backFrame = CGRect(x: 0, y: frameY, width: frame.width, height: fullHeight)
        
        let barFrame = CGRect(x: 0, y: barY, width: frame.width, height: barHeight)
        
        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            if stringFromClass.contains("BarBackground") {
                subview.frame = backFrame
            } else if stringFromClass.contains("BarContentView") {
                subview.frame = barFrame
            }
        }
    }
}
