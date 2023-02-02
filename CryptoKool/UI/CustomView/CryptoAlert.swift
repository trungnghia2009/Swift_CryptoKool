//
//  CryptoAlert.swift
//  CryptoKool
//
//  Created by trungnghia on 26/12/2022.
//

import UIKit

class CryptoAlert {
    
    private let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func showSimple(title: String, content: String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.controller.present(alert, animated: true)
        }
    }
    
    func showOptions(title: String,
                     content: String,
                     okButton: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in okButton() }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        DispatchQueue.main.async {
            self.controller.present(alert, animated: true)
        }
    }
}
