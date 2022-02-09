//
//  GCDUtils.swift
//  Beacon
//
//  Created by zeng on 2021/6/1.
//  Copyright © 2021 Beacon. All rights reserved.
//

import Foundation

public class GCDUtils {
    
    static let StatusQueue = DispatchQueue(label: "Status.Flag.Sync.Queue",
                                           qos: .userInteractive,
                                           attributes: .concurrent)
    
    public class func main(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    public class func sync(_ queue: DispatchQueue = DispatchQueue.main, block: () -> Void) {
        queue.sync {
            block()
        }
    }
    
    public class func async(_ queue: DispatchQueue = DispatchQueue.main, block: @escaping () -> Void) {
        queue.async {
            block()
        }
    }
    
    public class func delay(_ seconds: TimeInterval, queue: DispatchQueue = DispatchQueue.main, block: @escaping () -> Void) {
        queue.asyncAfter(deadline: DispatchTime.now() + seconds) { () -> Void in
            block()
        }
    }
    
    @discardableResult
    public class func cancelalbeDelay(_ seconds: TimeInterval, queue: DispatchQueue = DispatchQueue.main, block: @escaping () -> Void) -> DispatchWorkItem {
        let currentWorkItem = DispatchWorkItem {
            block()
        }
        
        queue.asyncAfter(deadline: DispatchTime.now() + seconds, execute: currentWorkItem)
        
        return currentWorkItem
    }
}
