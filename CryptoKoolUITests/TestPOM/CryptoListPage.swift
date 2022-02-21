//
//  CryptoListPage.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation
import XCTest

class ListPage: BasePage {
    
    static private let BTN_SEARCH = buttons["Search"]
    static private let BTN_MORE = buttons["more"]
    static private let BTN_INFO = buttons["info"]
    static private let LABEL_TITLE = staticTexts["Top 100"]
    
    
    static func verifyListPageOpened() {
        Logger.info(msg: "Verify List page opened")
        XCTAssert(LABEL_TITLE.waitExists(interval: 10))
    }
    
    static func navToInfomationPage() {
        Logger.info(msg: "Navigate to Infomation page")
        BTN_INFO.tap()
    }
    
    static func tapMoreBtn() {
        Logger.info(msg: "Tap More button")
        BTN_MORE.tap()
    }
    
    static func navToSearchPage() {
        Logger.info(msg: "Navigate to search page")
        BTN_SEARCH.tap()
    }
    
    static func navToDetailPage(labelContains: String) {
        Logger.info(msg: "Navigate to \(labelContains) detail page")
        cells.staticTexts.labelContains(text: labelContains).firstMatch.tap()
    }
}
