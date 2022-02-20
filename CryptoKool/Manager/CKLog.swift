//
//  CKLog.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import Foundation

final class CKLog {
    
    private init() {}
    
    static func info(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        print("\(Date.getCurrentTime()) \(String.getLatestFileName(path: file)):\(function):(\(line)):INFO - \(message)")
    }
    
    static func error(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        print("\(Date.getCurrentTime()) \(String.getLatestFileName(path: file)):\(function):(\(line)):ERROR - \(message)")
    }
    
    static func debug(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        print("\(Date.getCurrentTime()) \(String.getLatestFileName(path: file)):\(function):(\(line)):DEBUG - \(message)")
    }
}




