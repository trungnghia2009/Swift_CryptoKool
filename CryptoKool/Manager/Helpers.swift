//
//  Helpers.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import UIKit

final class Helpers {
    
    private init() {}
    
    static let shared = Helpers()
    
    func addHapticFeedback() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
