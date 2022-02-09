//
//  SynchronizedArray.swift
//  Beacon
//
//  Created by zeng on 2021/6/1.
//  Copyright © 2021 Beacon. All rights reserved.
//

import UIKit

class SynchronizedArray<T:Equatable> {
    private var array: [T] = []
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    
    public func append(newElement: T) {
        self.accessQueue.async(flags:.barrier) {
            self.array.append(newElement)
        }
    }
    
    public func removeElement(element: T) {
        self.accessQueue.async(flags:.barrier) {
            let indexArray = self.array.enumerated().filter({ (data) -> Bool in
                return data.element == element
            }).map({ (data) -> Int in
                return data.offset
            })
            
            if let i = indexArray.first {
                self.array.remove(at: i)
            }
        }
    }
    
    public func removeAll() {
        self.accessQueue.async(flags:.barrier) {
            self.array.removeAll()
        }
    }
    
    public func removeAtIndex(index: Int) {
        self.accessQueue.async(flags:.barrier) {
            self.array.remove(at: index)
        }
    }
    
    public var count: Int {
        var count = 0
        
        self.accessQueue.sync {
            count = self.array.count
        }
        
        return count
    }
    
    public func first() -> T? {
        var element: T?
        
        self.accessQueue.sync {
            if !self.array.isEmpty {
                element = self.array[0]
            }
        }
        
        return element
    }
    
    public func contains(element: T) -> Bool {
        var containElement: Bool = false
        self.accessQueue.sync {
            containElement = self.array.contains(element)
        }
        return containElement
    }
    
    public subscript(index: Int) -> T {
        set {
            self.accessQueue.async(flags:.barrier) {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            self.accessQueue.sync {
                element = self.array[index]
            }
            return element
        }
    }
}

