//
//  Logger.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation

class Logger {
    
    static func error(msg: String) {
        NSLog("*** ERROR \(msg)")
    }
  
    static func warning(msg: String) {
        NSLog("*** WARNING \(msg)")
    }
  
    static func info(msg: String) {
        NSLog("*** INFO \(msg)")
    }
}
