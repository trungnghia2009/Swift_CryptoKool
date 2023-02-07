//
//  CKLog.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import Foundation

public enum CKLog {
    
    enum LogLevel {
        case info
        case warning
        case error
        
        fileprivate var prefix: String {
            switch self {
            case .info:
                return "INFO"
            case .warning:
                return "WARNING"
            case .error:
                return "ERROR"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        
        private let currentDate = Date.getCurrentTime()
        
        var description: String {
            return "\(currentDate) \((file as NSString).lastPathComponent):\(line):\(function)"
        }
        
    
    }
    
    /// info log
    static func info(
        _ str: String,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file, function: function, line: line)
        CKLog.handleLog(level: .info, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    /// warning log
    static func warning(
        _ str: String,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file, function: function, line: line)
        CKLog.handleLog(level: .warning, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    /// error log
    static func error(
        _ str: String,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file, function: function, line: line)
        CKLog.handleLog(level: .error, str: str.description, shouldLogContext: shouldLogContext, context: context)
    }
    
    fileprivate static func handleLog(level: LogLevel, str: String, shouldLogContext: Bool, context: Context) {
        let logComponents = ["[\(level.prefix)]", str]
        
        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext {
            fullString = "\(context.description) → " + fullString
        }
        
        #if DEBUG
        print(fullString)
        #endif
    }
}




