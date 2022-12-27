//
//  Resolver+XCTest.swift
//  CryptoKoolTests
//
//  Created by trungnghia on 27/12/2022.
//

import Foundation
@testable import CryptoKool

extension Resolver {
    // MARK: - Mock Container
    static var mock = Resolver(child: .main)
    
    // MARK: - Register Mock Service
    static func registerMockServices_success_1() {
        root = Resolver.mock
        defaultScope = .graph
        Resolver.mock.register { CryptoService(coinGeckoService: MockCongeckoAPI_Success1()) }.implements(CryptoServiceInterface.self)
        Resolver.mock.register { CoreDataService(coreDataStack: TestCoreDataStack()) }.implements(CoreDataInterface.self)
    }
    
    static func registerMockServices_success_2() {
        root = Resolver.mock
        defaultScope = .graph
        Resolver.mock.register { CryptoService(coinGeckoService: MockCongeckoAPI_Success2()) }.implements(CryptoServiceInterface.self)
    }
    
    static func registerMockServices_success_3() {
        root = Resolver.mock
        defaultScope = .graph
        Resolver.mock.register { CryptoService(coinGeckoService: MockCongeckoAPI_Success3()) }.implements(CryptoServiceInterface.self)
    }
    
    static func registerMockServices_failed() {
        root = Resolver.mock
        defaultScope = .graph
        Resolver.mock.register { CryptoService(coinGeckoService: MockCongeckoAPI_Fail()) }.implements(CryptoServiceInterface.self)
        Resolver.mock.register { CoreDataService(coreDataStack: TestCoreDataStack()) }.implements(CoreDataInterface.self)
    }
    
    static func registerMockServices_search_no_data() {
        root = Resolver.mock
        defaultScope = .graph
        Resolver.mock.register { CryptoService(coinGeckoService: MockCongeckoAPI_NoData()) }.implements(CryptoServiceInterface.self)
    }
    
    static func registerMockServices_search_failed() {
        root = Resolver.mock
        defaultScope = .graph
        Resolver.mock.register { CryptoService(coinGeckoService: MockCongeckoAPI_Fail()) }.implements(CryptoServiceInterface.self)
    }
    
}
