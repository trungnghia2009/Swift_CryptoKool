//
//  XCUIElementExtension.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation

import Foundation
import XCTest

class XCUIElementExtensions {
  
  /**
   Wait for element appear. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitForElementToAppear(seconds: Int, element: XCUIElement) -> Bool {
    Logger.info(msg: "Waiting for Element to appear...")
    let result = element.waitForExistence(timeout: TimeInterval(seconds))
    return result
  }
  
  /**
   Wait for element disappear. Loop: it will take the snapshot of accessibility hierarchy and check if the element disappears.
   */
  func waitForElementToDisppear(seconds: Int, element: XCUIElement) -> Bool {
    Logger.info(msg: "Waiting for Element to disappear...")
    
    var timer = 0
    while element.waitForExistence(timeout: TimeInterval(1)) {
      timer = timer + 1
      if timer > seconds {
        return false
      }
    }
    return true
  }
  
  /**
   Wait for element's label appear. Loop: it will take the snapshot of accessibility hierarchy and check if the element's label appears.
   */
  func waitForLabelToAppear(seconds: Int, element: XCUIElement, label: String) -> Bool {
    Logger.info(msg: "Waiting for Element's label to appear...")
    if waitForElementToAppear(seconds: seconds, element: element) && element.label == label {
      return true
    }
    return false
  }
  
  /**
   Wait for element's label appear. Loop: it will take the snapshot of accessibility hierarchy and check if the element's label appears.
   */
  func waitForLabelToNotAppear(seconds: Int, element: XCUIElement, label: String) -> Bool {
    Logger.info(msg: "Waiting for Element's label to NOT appear...")
    if waitForElementToAppear(seconds: seconds, element: element) && element.label != label {
      return true
    }
    return false
  }
  
  /**
   Wait for element enabled. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitForElementEnabled(seconds: Int, element: XCUIElement) -> Bool {
    var timer = 0
    while element.waitForExistence(timeout: TimeInterval(1)) && element.isEnabled==false{
      timer = timer + 1
      if timer > seconds {
        return false
      }
    }
    return true
  }
  
  /**
   Wait for element disabled. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitForElementDisabled(seconds: Int, element: XCUIElement) -> Bool {
    Logger.info(msg: "Waiting for Element enabled...")
    var timer = 0
    while element.waitForExistence(timeout: TimeInterval(1)) && element.isEnabled==true{
      timer = timer + 1
      if timer > seconds {
        return false
      }
    }
    return true
  }
  
  /**
   Wait for element   . Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitForElementSelected(seconds: Int, element: XCUIElement) -> Bool {
    Logger.info(msg: "Waiting for Element Selected...")
    var timer = 0
    while element.waitForExistence(timeout: TimeInterval(1)) && element.isSelected==false{
      timer = timer + 1
      if timer > seconds {
        Logger.info(msg: "Unable to to wait for \(element) selected after waiting for \(seconds) seconds.")
        return false
      }
    }
    return true
    
  }
  
  /**
   Wait for element Unselected. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitForElementUnselected(seconds: Int, element: XCUIElement) -> Bool {
    Logger.info(msg: "Waiting for Element unselected...")
    var timer = 0
    while element.waitForExistence(timeout: TimeInterval(1)) && element.isSelected==true{
      timer = timer + 1
      if timer > seconds {
        Logger.info(msg: "Unable to to wait for \(element) unselected after waiting for \(seconds) seconds.")
        return false
      }
    }
    return true
  }
}



extension XCUIElement {
  /**
   Enable the switch.
   */
  func enableSwitch() {
    guard self.value as! String == "0" else {
      return
    }
    self.tap()
  }
  
  /**
   Disable the switch.
   */
  func disableSwitch() {
    guard self.value as! String == "1" else {
      return
    }
    self.tap()
  }
  
  /**
   Removes any current text in the field before typing in the new value.
   */
  
  func clearAndTypeText(text: String!) {
    guard text != nil else {
      return
    }
    let stringValue = self.value as? String
    self.tap()
    
    if stringValue != nil {
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: (stringValue?.count)!)
        self.typeText(deleteString)
    }
    self.typeText(text!)
  }
  
  /**
   Check if value of element contains a expected value.
   */
  func valueContains(expectedValue: String) -> Bool {
    
    if self.value == nil {
      if expectedValue == "" {
        Logger.info(msg: "Current actual value matched")
        return true
      } else{
        Logger.info(msg: "Current actual value not matched: \(expectedValue)")
        return false
      }
    } else {
      let actualValue = self.value as! String
      if actualValue.contains(expectedValue) {
        return true
      }
    }
    return false
  }
  
  /**
   Check if value of element should be a expected value.
   */
  func valueEqualTo(expectedValue: String) -> Bool {
    
    if self.value == nil {
      if expectedValue == "" {
        Logger.info(msg: "Current actual value matched")
        return true
      } else{
        Logger.info(msg: "Current actual value not matched: \(expectedValue)")
        return false
      }
    } else {
      let actualValue = self.value as! String
      if actualValue == expectedValue {
        return true
      }
    }
    return false
  }
  
  /**
   Check if label of element contains a expected text.
   */
  func labelContains(expectedLabel: String) -> Bool {
    let actualLabel = self.label
    if actualLabel.contains(expectedLabel) {
      return true
    }
    return false
  }
  
  
  /**
   Check if label of element equal to an expected text.
   */
  func labelEqualTo(expectedLabel: String) -> Bool {
    let actualLabel = self.label
    if actualLabel == expectedLabel {
      return true
    }
    return false
  }
  
  /**
   Check if identifier of element contains a expected text.
   */
  func identifierContains(expectedIdentifier: String) -> Bool {
    let actualIdentifier = self.identifier
    if actualIdentifier.contains(expectedIdentifier) {
      return true
    }
    return false
  }
  
  /**
   Check if identifier of element NOT contains a expected text.
   */
  func identifierNotContains(expectedIdentifier: String) -> Bool {
    let actualIdentifier = self.identifier
    if actualIdentifier.contains(expectedIdentifier) {
      return false
    }
    return true
  }
  
  /**
   Check if identifier of element equal to an expected text.
   */
  func identifierEqualTo(expectedIdentifier: String) -> Bool {
    let actualIdentifier = self.identifier
    if actualIdentifier == expectedIdentifier {
      return true
    }
    return false
  }
  
  /**
   Check if placeholder of element contains a expected text.
   */
  func placeholderContains(expectedPlaceholder: String) -> Bool {
    let actualPlaceholder = self.placeholderValue!
    if actualPlaceholder.contains(expectedPlaceholder) {
      return true
    }
    return false
  }
  
  
  /**
   Check if placeholder of element equal to an expected text.
   */
  func placeholderEqualTo(expectedPlaceholder: String) -> Bool {
    let actualPlaceholder = self.placeholderValue!
    if actualPlaceholder == expectedPlaceholder {
      return true
    }
    return false
  }
  
  /**
   Wait for element appear. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitExists() -> Bool {
    if XCUIElementExtensions().waitForElementToAppear(seconds: TestConfig.Waiting().ElementWaitingTime, element: self) {
      return true
    } else {
      return false
    }
  }
  
  
  /**
   Wait for an interval until element appear. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitExists(interval: Int) -> Bool {
    if XCUIElementExtensions().waitForElementToAppear(seconds: interval, element: self) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Wait for element disappear. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitNotExists() -> Bool {
    if XCUIElementExtensions().waitForElementToDisppear(seconds: TestConfig.Waiting().ElementWaitingTime, element: self) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Wait for an interval until element disappear. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitNotExists(interval: Int) -> Bool {
    if XCUIElementExtensions().waitForElementToDisppear(seconds: interval, element: self) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Wait for an interval until element's lebel appear. Loop: it will take the snapshot of accessibility hierarchy and check if the element's label appears.
   */
  func waitLabelExists(interval: Int, label: String) -> Bool {
    if XCUIElementExtensions().waitForLabelToAppear(seconds: interval, element: self, label: label) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Wait for an interval until element's lebel NOT appear. Loop: it will take the snapshot of accessibility hierarchy and check if the element's label appears.
   */
  func waitLabelNotExists(interval: Int, label: String) -> Bool {
    if XCUIElementExtensions().waitForLabelToNotAppear(seconds: interval, element: self, label: label) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Wait for an interval until element's label contains. Loop: it will take the snapshot of accessibility hierarchy and check if the element's label appears.
   */
  func waitLabelContains(interval: Int, text: String) -> Bool {
    
    var timer = 0
    self.waitForElementToAppear(interval: 5)
    while timer < interval {
      if self.label.contains(text) {
        return true
      } else {
        if timer == interval {
          break
        } else {
          timer = timer + 1
          sleep(1)
        }
      }
    }
    return false
  }
  
  /**
   Wait for an interval until element's value contains. Loop: it will take the snapshot of accessibility hierarchy and check if the element's label appears.
   */
  func waitValueContains(interval: Int, text: String) -> Bool {
    
    var timer = 0
    
    if self.value == nil {
      if text == "" {
        Logger.info(msg: "Current actual value matched")
        return true
      } else {
        Logger.info(msg: "Current actual value not matched: \(text)")
        return false
      }
    } else {
      while timer < interval {
        let actualValue = self.value as! String
        Logger.info(msg: "Refreshing the accessibility: \(tables.count)...")
        Logger.info(msg: "Current actual value 0: \(actualValue)")
        if actualValue.contains(text) {
          Logger.info(msg: "Current actual value matched: \(actualValue)")
          return true
        } else {
          Logger.info(msg: "Current actual value in else: \(actualValue)")
          if timer == interval {
            break
          } else {
            timer = timer + 1
            sleep(1)
          }
        }
      }
    }
    return false
  }
  
  /**
   Wait for an interval until element's value NOT contains. Loop: it will take the snapshot of accessibility hierarchy and check if the element's label appears.
   */
  func waitValueNotContains(interval: Int, text: String) -> Bool {
    
    var timer = 0
    if self.value == nil {
      if text == "" {
        Logger.info(msg: "Current actual value matched")
        return true
      } else{
        Logger.info(msg: "Current actual value not matched: \(text)")
        return false
      }
    }else {
      while timer < interval {
        let actualValue = self.value as! String
        Logger.info(msg: "Refreshing the accessibility: \(tables.count)...")
        Logger.info(msg: "Current actual value: \(actualValue)")
        
        if actualValue.contains(text) {
          if timer == interval {
            break
          } else {
            timer = timer + 1
            sleep(1)
          }
        } else {
          return true
        }
      }
    }
    return false
  }
  
  
  /**
   Wait for an interval until element's placeholder contains. Loop: it will take the snapshot of accessibility hierarchy and check if the element's label appears.
   */
  func waitPlaceholderContains(interval: Int, text: String) -> Bool {
    
    var timer = 0
    
    while timer < interval {
      if (self.placeholderValue?.contains(text))! {
        return true
      } else {
        if timer == interval {
          break
        } else {
          timer = timer + 1
          sleep(1)
        }
      }
    }
    return false
  }
  
  
  /**
   Wait for an interval until element enabled. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitEnabled(interval: Int) -> Bool {
    if XCUIElementExtensions().waitForElementEnabled(seconds: interval, element: self) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Wait for an interval until element disabled. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitDisabled(interval: Int) -> Bool {
    if XCUIElementExtensions().waitForElementDisabled(seconds: interval, element: self) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Wait for an interval until element Selected. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitSelected(interval: Int) -> Bool {
    if XCUIElementExtensions().waitForElementSelected(seconds: interval, element: self) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Wait for an interval until element unselected. Loop: it will take the snapshot of accessibility hierarchy and check if the element appears.
   */
  func waitUnselected(interval: Int) -> Bool {
    if XCUIElementExtensions().waitForElementUnselected(seconds: interval, element: self) {
      return true
    } else {
      return false
    }
  }
  
  /**
   Force Tap on Element in case it is not hittable.
   */
  func forceTap(){
    if self.isHittable {
      self.tap()
    } else {
      let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
      coordinate.tap()
      
    }
  }
  
  /**
   Get Element's Min Location.
   */
  func getMinLocation() -> Dictionary<String, Int>{
    var location: Dictionary<String, Int> = [:]
    location["X"] = Int("\(self.frame.minX)".components(separatedBy: ".")[0])
    location["Y"] = Int("\(self.frame.minY)".components(separatedBy: ".")[0])
    return location
  }
  
  /**
   Drag and drop object to new coordinate
   */
  func dragDropToNewCoordinate(ObjectDx: Double, ObjectDy: Double, TargetDx: Double, TargetDy: Double){
    let beginningPoint = self.coordinate(withNormalizedOffset:CGVector(dx: ObjectDx, dy: ObjectDy))
    let scrollVector = CGVector(dx: TargetDx, dy: TargetDy)
    beginningPoint.press(forDuration: 0.5, thenDragTo: beginningPoint.withOffset(scrollVector))
  }
  
  /**
   Wait for element to appear with interval
   */
  func waitForElementToAppear(interval: Int) {
    if XCUIElementExtensions().waitForElementToAppear(seconds: interval, element: self) {
        Logger.info(msg: "Element appeared...")
    }
  }
  
  /**
   Wait for element to disappear with interval
   */
  func waitForElementToDisappear(interval: Int) {
    if XCUIElementExtensions().waitForElementDisabled(seconds: interval, element: self) {
         Logger.info(msg: "Element disappeared...")
    }
  }
  
  /**
   Get width or heigh of frame
   */
  func getWidth() -> Int {
    return Int(self.frame.size.width)
  }
  func getHeight() -> Int {
    return Int(self.frame.size.height)
  }
  
  func getPercentageOfWidth(precent: Int) -> Int {
    return (getWidth() * precent) / 100
  }
  
  func getPercentageOfHeigh(precent: Int) -> Int {
    return (getHeight() * precent) / 100
  }
  
  /**
   Tap with Offset
   */
  func tapWithOffset(x: Int, y: Int) {
    self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: x, dy: y)).tap()
  }
  
  /**
   Tap if exists
   */
  func tapIfExists() {
    if self.exists {
      self.tap()
    }
  }
  
  /**
   Get Element's X Location.
   */
  func getXLocation() -> Int?{
    var location: Dictionary<String, Int> = [:]
    location["X"] = Int("\(self.frame.minX)".components(separatedBy: ".")[0])
    return location["X"]
  }
  
  /**
   Get Element's Y Location.
   */
  func getYLocation() -> Int?{
    var location: Dictionary<String, Int> = [:]
    location["Y"] = Int("\(self.frame.minY)".components(separatedBy: ".")[0])
    return location["Y"]
  }
  
  /**
   Get Element's Value.
   */
  func getValue() -> String? {
    if self.value == nil {
      return ""
    }
    return (self.value as! String)
  }
  
  /**
   Get Frame's Width
   */
  func getFrameWidth() -> Int{
    var size: Dictionary<String, Int> = [:]
    size["W"] = Int("\(self.frame.size.width)".components(separatedBy: ".")[0])
    return size["W"]!
  }
  
  /**
   Get Frame's Width
   */
  func getFrameHeight() -> Int{
    var size: Dictionary<String, Int> = [:]
    size["H"] = Int("\(self.frame.size.height)".components(separatedBy: ".")[0])
    return size["H"]!
  }
    
    /**
     elelmet with offest.
     */
    func offset(x: Int, y: Int) ->XCUICoordinate {
        return self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: x, dy: y))
    }
    
    func elementOffset(x: Int, y: Int) ->XCUIElement {
        return self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).referencedElement
    }

}
