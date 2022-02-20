//
//  SafeArray.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import Foundation

class SafeArray<T: Equatable> {
    private var _array = [T]()
    private let concurrentQueue = DispatchQueue(label: "SafeArray", attributes: .concurrent)
    
    subscript(idx: Int) -> T? {
        get {
            var result: T?
            self.concurrentQueue.sync {
                if idx >= 0 && idx < self._array.count {
                    result = self._array[idx]
                }
            }
            return result
        }
        
        set {
            if let val = newValue {
                self.concurrentQueue.async(flags: .barrier) {
                    if idx >= 0 && idx < self._array.count {
                        self._array[idx] = val
                    }
                }
            }
        }
    }
    var last: T? {
        var result: T?
        self.concurrentQueue.sync {
            result = self._array.last
        }
        return result
    }
    
    var array: [T] {
        var result = [T]()
        self.concurrentQueue.sync {
            result.append(contentsOf: self._array)
        }
        return result
    }
    
    func append(_ newElement: T) {
        self.concurrentQueue.async(flags: .barrier) {
            self._array.append(newElement)
        }
    }
    
    func append(contentsOf elements: [T]) {
        self.concurrentQueue.async(flags: .barrier) {
            self._array.append(contentsOf: elements)
        }
    }
    
    func remove(_ element: T) {
        self.concurrentQueue.async(flags: .barrier) {
            if let idx = self._array.firstIndex(of: element) {
                self._array.remove(at: idx)
            }
        }
    }
}
