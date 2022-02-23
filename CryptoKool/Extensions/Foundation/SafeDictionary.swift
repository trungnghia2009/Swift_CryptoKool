//
//  SafeDictionary.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import Foundation

class SafeDictionary<K: Hashable, V> {
    private var dict = [K: V]()
    private let concurrentQueue = DispatchQueue(label: "SafeDictionary", attributes: .concurrent)
    
    subscript(key: K) -> V? {
        get {
            var value: V?
            concurrentQueue.sync { [weak self] in
                value = self?.dict[key]
            }
            return value
        }
        set {
            concurrentQueue.async(flags: .barrier) { [weak self] in
                self?.dict[key] = newValue
            }
        }
    }
    
    func removeAll() {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            self?.dict.removeAll()
        }
    }
}
