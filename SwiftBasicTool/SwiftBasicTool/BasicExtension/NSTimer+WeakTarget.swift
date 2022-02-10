//
//  CGFloat+.swift
//  Beacon
//
//  Created by zeng on 2021/6/1.
//  Copyright © 2021 Beacon. All rights reserved.
//

import Foundation

// MARK: weak target的timer
private class Block<T> {
    let f : T
    init (_ f: T) { self.f = f }
}

extension Timer {
    
    static func weakTarget_scheduledTimerWithTimeInterval(_ ti: TimeInterval, block: @escaping ()->(), repeats: Bool) -> Timer {
        return self.scheduledTimer(timeInterval: ti, target:
            self, selector: #selector(weakTarget_blcokInvoke(_:)), userInfo: Block(block), repeats: repeats)
    }
    
    @objc static func weakTarget_blcokInvoke(_ timer: Timer) {
        if let block = timer.userInfo as? Block<()->()> {
            block.f()
        }
    }
}
