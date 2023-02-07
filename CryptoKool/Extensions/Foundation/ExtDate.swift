//
//  Date.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import Foundation

extension Date {
    static func getCurrentTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let formattedDate = format.string(from: Date())
        return formattedDate
    }
}
