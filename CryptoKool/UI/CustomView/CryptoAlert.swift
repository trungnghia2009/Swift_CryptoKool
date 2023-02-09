//
//  CryptoAlert.swift
//  CryptoKool
//
//  Created by trungnghia on 26/12/2022.
//

import UIKit

struct AlertInfo {
    let controller: UIViewController
    let title: String
    let content: String
}

struct CryptoAlert {
    
    private let okBtnLabel = CKLanguage.text("alert_ok_button", comment: "OK")
    private let cancelBtnLabel = CKLanguage.text("alert_cancel_button", comment: "Cancel")
    
    func showSimple(alertInfo: AlertInfo) {
        let alert = UIAlertController(title: alertInfo.title, message: alertInfo.content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okBtnLabel, style: .default))
        DispatchQueue.main.async {
            alertInfo.controller.present(alert, animated: true)
        }
    }
    
    func showOptions(alertInfo: AlertInfo,
                     okButton: @escaping () -> Void) {
        let alert = UIAlertController(title: alertInfo.title, message: alertInfo.content, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okBtnLabel, style: .default) { _ in okButton() }
        let cancelButton = UIAlertAction(title: cancelBtnLabel, style: .cancel) { _ in }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        DispatchQueue.main.async {
            alertInfo.controller.present(alert, animated: true)
        }
    }
}
