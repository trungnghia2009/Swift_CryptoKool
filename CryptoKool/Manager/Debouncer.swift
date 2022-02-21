//
//  Debouncer.swift
//  CryptoKool
//
//  Created by trungnghia on 20/02/2022.
//

import Foundation

final class Debouncer: NSObject {
    private var callback: (() -> Void)
    var delay: Double
    weak var timer: Timer?
    
    init(delay: Double, callback: @escaping (() -> Void)) {
        self.delay = delay
        self.callback = callback
    }
    
    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc private func fireNow() {
        self.callback()
    }
}
