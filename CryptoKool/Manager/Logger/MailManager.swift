//
//  MailManager.swift
//  Logger
//
//  Created by trungnghia on 08/02/2023.
//

import UIKit
import MessageUI

struct MailConstants {
    static let email = "trantrungnghia0603@gmail.com"
    static let subject = "Report of Error in CryptoKool application"
    static let body = """
    Hello CryptoKool team,
    I have following issues:
    - App version: \(Config.version)(\(Config.build))
    - iOS version: \(DeviceInfo.version)
    with best regard
    """
    static let mineType = "text/plain"
}

class MailManager {
    private let logAttachment = LogFileManager.shared.getFileData()
    
    public func sendEmailWithLogAttachment(controller: UIViewController, delegate: MFMailComposeViewControllerDelegate) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = delegate
            mail.setToRecipients([MailConstants.email])
            mail.setSubject(MailConstants.subject)
            mail.setMessageBody(MailConstants.body, isHTML: false)
            mail.addAttachmentData(logAttachment ?? Data() , mimeType: MailConstants.mineType, fileName: LogFileManager.shared.name)
            controller.present(mail, animated: true)
        } else {
            // Prompt a popup about configuring the email
            let alert = CryptoAlert()
            let alertInfo = AlertInfo(controller: controller, title: "Opps!!", content: "Please setup your email")
            alert.showSimple(alertInfo: alertInfo)            
        }
    }
}
