//
//  UIApplication+.swift
//  SwiftBasicTool
//
//  Created by Stephen.Zeng on 2022/2/9.
//

import UIKit

extension UIApplication {
    
    var kWindow: UIWindow? {
        if #available(iOS 15.0, *) {
            // Get connected scenes
            return UIApplication.shared.connectedScenes
                // Keep only active scenes, onscreen and visible to the user
//                .filter { $0.activationState == .foregroundActive }
                // Keep only the first `UIWindowScene`
                .first(where: { $0 is UIWindowScene })
                // Get its associated windows
                .flatMap({ $0 as? UIWindowScene })?.windows
                // Finally, keep only the key window
                .first(where: \.isKeyWindow)
        } else if #available(iOS 13.0, *) {
            // keep only the key window
            return UIApplication.shared.windows.first(where: \.isKeyWindow)
        } else {
            // fetch the key window
            return UIApplication.shared.keyWindow
        }
    }
    
}
