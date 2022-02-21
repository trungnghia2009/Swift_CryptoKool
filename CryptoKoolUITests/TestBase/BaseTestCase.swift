//
//  BaseTestCase.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import XCTest
import Foundation


class BaseTestCase: XCTestCase {
    
    var cleanUpAction: Bool?
    static var fristTimeLaunchApp = true
    
    func beginTest() {
        cleanUpAction = true
    }
    
    func finishTest() {
        cleanUpAction = false
    }
    
    override func setUp() {
        // Set cleanup = true
        beginTest()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Only launch app for first time run
        if BaseTestCase.fristTimeLaunchApp == true {
            XCUIApplication().launch()
            BaseTestCase.fristTimeLaunchApp = false
        }
    }
    
    override func tearDown() {
        // Clean up and take screen shot once Test case get failed
        if cleanUpAction == true {
            takeScreenshots()
            XCUIApplication().launch()
        }
    }
    
    func takeScreenshots() {
        Logger.info(msg: "Taking Screenshot for " + self.name)
        let attachment = XCTAttachment(screenshot: XCUIApplication().screenshot())
        attachment.name = self.name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

  
}
