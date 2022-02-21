//
//  TestConfig.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 21/02/2022.
//

import Foundation

import Foundation

struct TestConfig {

  struct Waiting {
    let ElementWaitingTime    = 5
    
    // Call duration in seconds
    let CallDurationQuick: UInt32     = 2
    let CallDurationShort: UInt32     = 60
    let CallDurationMedium: UInt32    = 60 * 3
    let CallDurationLong: UInt32      = 60 * 60 * 8
  }
  
}
