//
//  GCDTimer.swift
//  Beacon
//
//  Created by zeng on 2021/6/1.
//  Copyright © 2021 Beacon. All rights reserved.
//

import UIKit
    
private let timerQueue = DispatchQueue(label: "com.timer.queue", attributes: [])
    
final class GCDTimer: NSObject {
    
    private var timer: DispatchSourceTimer?
    
    private var timerCount: Int = 0
    
    private var isSuspended: Bool = false
    
    var active: Bool {
        return timer != nil
    }
    
    deinit {
        cancel()
    }
    
    func start(milliseonds intervalInMilliseonds: Int, repeats: Bool = false, handler: @escaping () -> Void) {
        
        cancel()
        
        let timer = DispatchSource.makeTimerSource(queue: timerQueue)
        self.timer = timer
        
        timer.schedule(deadline: .now() + .milliseconds(intervalInMilliseonds), repeating: .milliseconds(intervalInMilliseonds))
        timer.setEventHandler { [weak self] in
            if !repeats {
                self?.cancel()
            }
            DispatchQueue.main.async(execute: handler)
        }
        timer.resume()
        isSuspended = false
    }
    
    func start(_ interval: Int, repeats: Bool = false, handler: @escaping () -> Void) {
        
        cancel()
        
        let timer = DispatchSource.makeTimerSource(queue: timerQueue)
        self.timer = timer
        
        timer.schedule(deadline: .now() + .seconds(interval), repeating: .seconds(interval))
        timer.setEventHandler { [weak self] in
            if !repeats {
                self?.cancel()
            }
            DispatchQueue.main.async(execute: handler)
        }
        timer.resume()
        isSuspended = false
    }
    
    func start(milliseonds intervalInMilliseonds: Int, repeatCount: Int = 1, handler: @escaping (Int) -> Void) {
        
        cancel()
        
        let timer = DispatchSource.makeTimerSource(queue: timerQueue)
        self.timer = timer
        self.timerCount = 0
        
        timer.schedule(deadline: .now() + .milliseconds(intervalInMilliseonds), repeating: .milliseconds(intervalInMilliseonds))
        timer.setEventHandler { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.timerCount = strongSelf.timerCount+1
            if strongSelf.timerCount >= repeatCount {
                strongSelf.cancel()
            }
            DispatchQueue.main.async {
                handler(strongSelf.timerCount)
            }
        }
        timer.resume()
        isSuspended = false
    }
    
    func start(_ interval: Int, repeatCount: Int = 1, handler: @escaping (Int) -> Void) {
        
        cancel()
        
        let timer = DispatchSource.makeTimerSource(queue: timerQueue)
        self.timer = timer
        self.timerCount = 0
        
        timer.schedule(deadline: .now() + .seconds(interval), repeating: .seconds(interval))
        timer.setEventHandler { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.timerCount = strongSelf.timerCount+1
            if strongSelf.timerCount >= repeatCount {
                strongSelf.cancel()
            }
            DispatchQueue.main.async {
                handler(strongSelf.timerCount)
            }
        }
        timer.resume()
        isSuspended = false
    }

    func pause() {
        guard let timer = timer, !isSuspended else { return }
        timer.suspend()
        isSuspended = true
    }
    
    func resume() {
        guard let timer = timer, !timer.isCancelled else { return }
        timer.resume()
        isSuspended = false
    }
    
    func cancel() {
        guard let timer = timer else { return }
        if isSuspended {
            timer.resume()
        }
        timer.cancel()
        self.timer = nil
        isSuspended = false
    }
}
