//
//  LogFileManager.swift
//  Logger
//
//  Created by trungnghia on 08/02/2023.
//

import Foundation

struct LogFileManager {
    
    static let shared = LogFileManager()
    
    private let fileName = "logs.txt"
    private let maxSize = 1_048_576 * 10 // 1MB * 10
    private let fileManager = FileManager.default
    private let logQueue = DispatchQueue(label: "logQueue", attributes: .concurrent)
    
    var name: String {
        return fileName
    }
    
    private init() {}
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getFilePath() -> String {
        if #available(iOS 16.0, *) {
           return getDocumentsDirectory().appendingPathComponent(fileName).path()
        }
        return getDocumentsDirectory().appendingPathExtension(fileName).path
    }
    
    private func write(_ text: String) {
        let path = getFilePath()
        let writeText = "\(text)\n"
        
        let fileSize = fileManager.sizeOfFile(atPath: path) ?? 0
        
        if fileSize >= maxSize {
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                print("Cannot remove file with error: \(error)")
            }
        }
        
        if !fileManager.fileExists(atPath: path) {
            do {
                try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("Cannot write with error: \(error)")
            }
        }
        
        if let fileHandle = FileHandle(forWritingAtPath: path) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(writeText.data(using: String.Encoding.utf8)!)
            fileHandle.closeFile()
        }
    }
    
    func writeLog(_ text: String) {
        logQueue.async(flags: .barrier) {
            self.write(text)
        }
    }
    
    func getFileData() -> Data? {
        guard let fileHandle = FileHandle(forReadingAtPath: getFilePath()) else { return nil }
        return fileHandle.readDataToEndOfFile()
    }
    
}

private extension FileManager {
    func sizeOfFile(atPath path: String) -> Int64? {
        guard let attrs = try? attributesOfItem(atPath: path) else {
            return nil
        }
        return attrs[.size] as? Int64
    }
}
