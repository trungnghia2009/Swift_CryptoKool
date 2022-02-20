//
//  String.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import Foundation

extension String {
    static func getLatestFileName(path: String) -> String {
        let arrayString = path.components(separatedBy: "/")
        return arrayString.last?.components(separatedBy: ".")[0] ?? "ErrorFileName"
    }
}
