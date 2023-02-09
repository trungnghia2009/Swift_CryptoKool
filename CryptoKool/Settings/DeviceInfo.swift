//
//  DeviceInfo.swift
//  Logger
//
//  Created by trungnghia on 09/02/2023.
//

import UIKit

public struct DeviceInfo {
    public static let model = UIDevice.current.model // e.g. @"iPhone", @"iPod touch"
    public static let modelType = UIDevice.modelIdentifier() // e.g. iPhone14,7
    public static let systemName = UIDevice.current.systemName //  e.g. @"iOS"
    public static let version = UIDevice.current.systemVersion //e.g. @"15.5"
    public static let localizedModel = UIDevice.current.localizedModel // localized version of model
    public static let deviceID = UIDevice.current.identifierForVendor?.uuidString // device UUID
}

extension UIDevice {
    static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
