//
//  DeviceInfo.swift
//  Logger
//
//  Created by trungnghia on 09/02/2023.
//

import UIKit

public struct DeviceInfo {
    public static let model = UIDevice.modelName
    public static let systemName = UIDevice.current.systemName
    public static let version = UIDevice.current.systemVersion
    static let totalDiskSpace = DiskStatus.totalDiskSpace
    static let usedDiskSpace = DiskStatus.usedDiskSpace
}

fileprivate struct DiskStatus {
    
    //MARK: Get String Value
    static var totalDiskSpace: String {
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes ?? 0, countStyle: ByteCountFormatter.CountStyle.file)
    }
    
    static var usedDiskSpace: String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes ?? 0, countStyle: ByteCountFormatter.CountStyle.file)
    }
    
    //MARK: Get raw value
    private static var totalDiskSpaceInBytes: Int64? {
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String) {
            return (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
        }
        return nil
    }
    
    private static var freeDiskSpaceInBytes: Int64? {
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String) {
            return (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
        }
        return nil
    }
    
    private static var usedDiskSpaceInBytes: Int64? {
        guard let totalDiskSpaceInBytes, let freeDiskSpaceInBytes else { return nil }
        let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
        return usedSpace
    }
}
