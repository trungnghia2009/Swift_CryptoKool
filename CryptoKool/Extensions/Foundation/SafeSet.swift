//
//  SafeSet.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import Foundation

class SafeSet<T: Hashable> {
    private var set = Set<T>()
    private let concurrentQueue = DispatchQueue(label: "SafeSet", attributes: .concurrent)
    
    func insert(_ newElement: T) {
        concurrentQueue.async(flags: .barrier) {
            self.set.insert(newElement)
        }
    }
    
    func remove(_ member: T) {
        concurrentQueue.async(flags: .barrier) {
            self.set.remove(member)
        }
    }
    
    func contains(_ member: T) -> Bool {
        var value = false
        concurrentQueue.sync {
            value = set.contains(member)
        }
        return value
    }
}
