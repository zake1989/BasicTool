//
//  Collection+.swift
//  MYXJ
//
//  Created by zeng on 2018/10/11.
//  Copyright © 2018 Meitu. All rights reserved.
//

import UIKit

extension Collection {
    // 安全获取列表类的第几号元素
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}

/**
 安全操作 get, set, insert, delete 数组
 操作中如果发生错误 会被打印输出
 */
extension Array {
    /**
     安全删除s
     */
    mutating func remove(safeAt index: Index) {
        guard indices.contains(index) else {
            assertionFailure("Index out of bounds while deleting item at index \(index) in \(self). This action is ignored.")
            return
        }
        
        remove(at: index)
    }
    
    /**
     安全插入
     */
    mutating func insert(_ element: Element, safeAt index: Index) {
        guard indices.contains(index) else {
            assertionFailure("Index out of bounds while inserting item at index \(index) in \(self). This action is ignored")
            return
        }
        
        insert(element, at: index)
    }
    
    /**
     安全 获取 替换
     */
    subscript (safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }
        set {
            guard index < count else { return }
            remove(safeAt: index)
            if let element = newValue {
                if index > count - 1 {
                    append(element)
                } else {
                    insert(element, safeAt: index)
                }
            }
        }
    }
}
