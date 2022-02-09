//
//  AsyncOperation.swift
//  Beacon
//
//  Created by zeng on 2021/6/1.
//  Copyright © 2021 Beacon. All rights reserved.
//

import UIKit

enum State: String {
    case ready
    case executing
    case finished
    
    var keyPath: String {
        return "is\(rawValue.capitalized)"
    }
    
}

class AsyncOperation: Operation {
    
    private var controlState: State = State.ready
    
    public var state: State {
        get {
            GCDUtils.StatusQueue.sync {
                return controlState
            }
        }
        set {
            let oldValue = state
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
            GCDUtils.StatusQueue.async(flags: .barrier) {
                self.controlState = newValue
            }
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isFinished: Bool {
        return isCancelled || state == .finished
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled || state == .finished {
            return
        }
        state = .executing
        main()
    }
    
    override func cancel() {
        super.cancel()
        if state == .executing {
            state = .finished
        }
    }

}
