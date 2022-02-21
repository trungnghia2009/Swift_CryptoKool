//
//  SearchPage.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation
import XCTest

class SearchPage: BasePage {
    
    static private let BTN_CANCEL = buttons["Cancel"]
    static private let SEARCH = searchFields.firstMatch
    
    static func tapCancelBtn() {
        Logger.info(msg: "Tap Cancel button")
        BTN_CANCEL.tap()
    }
    
    static func search(keyword: String) {
        Logger.info(msg: "Type: \(keyword)")
        SEARCH.typeText(keyword)
    }
    
    static func verifySearchPageOpened() {
        Logger.info(msg: "Verify Search page opened")
        XCTAssert(tables["Please type your keyword."].waitExists(interval: 3))
    }
    
    static func verifySearchResult() {
        Logger.info(msg: "Verify search result")
        XCTAssert(cells.firstMatch.waitExists(interval: 3))
    }
    
    static func navigateToFirstSearchResult() {
        Logger.info(msg: "Navigate to first Search result")
        cells.element(boundBy: 0).tap()
    }
}
