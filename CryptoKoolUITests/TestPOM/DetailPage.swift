//
//  DetailPage.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation
import XCTest

class DetailPage: BasePage {
    
    static private let LABEL_HOMEPAGE = staticTexts.labelContains(text: "Homepage").element
    static private let BTN_BACK = buttons["Top 100"]
    static private let BTN_SEARCH_BACK = buttons["Back"]
    
    static func verifyDetailPageOpened() {
        Logger.info(msg: "Verify Detail page opened")
        XCTAssert(LABEL_HOMEPAGE.waitExists(interval: 3))
    }
    
    static func tapBackBtn() {
        Logger.info(msg: "Tap back button")
        BTN_BACK.tapIfExists()
        BTN_SEARCH_BACK.tapIfExists()
    }
    
}
