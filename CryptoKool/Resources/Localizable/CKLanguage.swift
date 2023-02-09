//
//  CKLanguage.swift
//  CryptoKool
//
//  Created by trungnghia on 09/02/2023.
//

import Foundation

struct CKLanguage {
    static func text(_ str: String, comment: String? = nil) -> String {
        return NSLocalizedString(str, comment: comment ?? "")
    }
}
