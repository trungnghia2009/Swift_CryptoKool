//
//  ExtUILabel.swift
//  CryptoKool
//
//  Created by trungnghia on 09/02/2023.
//

import UIKit

extension UILabel {
    @IBInspectable public var localizedText: String? {
        get {
            return text
        }
        set {
            text = NSLocalizedString(newValue ?? "", comment: "")
        }
    }
}
