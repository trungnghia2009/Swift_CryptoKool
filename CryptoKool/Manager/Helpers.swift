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
    
    func getJsonData(name: String) -> Data? {
            guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
                return nil
            }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch let error as NSError {
                CKLog.error(message: "getJsonData got error: \(error), \(error.userInfo)")
                return nil
            }
        }

}
