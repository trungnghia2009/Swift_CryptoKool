//
//  FirstPage.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation

class FirstPage: BasePage {
    
    static private let LABEL_TITLE = staticTexts["APIs was provided by"]
    static private let BTN_START_NOW = buttons["Start now"]
    
    static func navToListPage() {
        Logger.info(msg: "Navigate to List page")
        BTN_START_NOW.tap()
    }
    
    static func checkFirstPageExist() -> Bool {
        Logger.info(msg: "Check First page exist")
        return LABEL_TITLE.waitExists(interval: 1)
    }
}
