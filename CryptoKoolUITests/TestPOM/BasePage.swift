//
//  BasePage.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation
import XCTest

class BasePage: XCUIApplication {
    static let app              = XCUIApplication()
    static let navigationBars   = app.navigationBars
    static let tables           = app.tables
    static let cells            = tables.cells
    static let switches         = app.switches
    static let buttons          = app.buttons
    static let radioButtons     = app.radioButtons
    static let checkBoxes       = app.checkBoxes
    static let staticTexts      = app.staticTexts
    static let textFields       = app.textFields
    static let secureTextFields = app.secureTextFields
    static let alerts           = app.alerts
    static let otherElements    = app.otherElements
    static let collectionViews  = app.collectionViews
    static let scrollViews      = app.scrollViews
    static let searchFields     = app.searchFields
    static let statusBars       = app.statusBars
}
