//
//  XCUIElementQueryExtension.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation
import XCTest

extension XCUIElementQuery{
  
  func labelStartWith(startString: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "label BEGINSWITH '\(startString)'"))
  }
  
  func labelEndWith(startString: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "label ENDSWITH '\(startString)'"))
  }
  
  func labelContains(text: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "label CONTAINS '\(text)'"))
  }
  
  func identifierStartWith(startString: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "identifier BEGINSWITH '\(startString)'"))
  }
  
  func identifierEndWith(startString: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "identifier ENDSWITH '\(startString)'"))
  }
  
  func identifierContains(text: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "identifier CONTAINS '\(text)'"))
  }
  
  func placeholderValueStartWith(startString: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "placeholderValue BEGINSWITH '\(startString)'"))
  }
  
  func placeholderValueEndWith(startString: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "placeholderValue ENDSWITH '\(startString)'"))
  }
  
  func placeholderValueContains(text: String) -> XCUIElementQuery{
    return containing(NSPredicate(format: "placeholderValue CONTAINS '\(text)'"))
  }
  
}
