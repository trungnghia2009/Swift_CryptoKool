//
//  AppConfiguration.swift
//  Logger
//
//  Created by trungnghia on 08/02/2023.
//

import Foundation

public enum Enviroment: String {
    case Debug
    case Release
}

public struct Config {
    
    // Using configuration in Target -> select the main app -> Build Settings -> click '+' -> add new key
    public static var enviroment: Enviroment? {
        guard let name = Bundle.main.infoDictionary?["SCHEME_NAME"] as? String,
              let enviroment = Enviroment.init(rawValue: name) else {
            return nil
        }
        return enviroment
    }
    
    // Using configuration file .xcconfig
    public static let featureEnabled = (Bundle.main.infoDictionary?["FEATURES_ENABLED"] as? NSString)?.boolValue
    public static let bffUrl = (Bundle.main.infoDictionary?["BFF_URL"] as? String)?.replacingOccurrences(of: "\\", with: "")
    
    // Using from system key
    public static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    public static let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    public static let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
}
