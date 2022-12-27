//
//  CryptoDetailVMTest.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

import XCTest
@testable import CryptoKool
import Combine

class CryptoDetailVMTest: XCTestCase {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let cryptoDetailEntity = CryptoDetailEntity(id: "id",
                                                symbol: "symbol",
                                                name: "crypto",
                                                imageURL: nil,
                                                homePage: [String](),
                                                currentPrice: nil,
                                                priceChangePercentage24h: nil,
                                                rank: 999,
                                                high24h: nil,
                                                low24h: nil,
                                                marketCap: nil)

    func test_fetch_detail_successfully1() throws {
        Resolver.registerMockServices_success_1()
        let sut = CryptoDetailVM(entity: cryptoDetailEntity)
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getSymbol(), "\(cryptoDetailEntity.symbol.uppercased())/USD")
        XCTAssertEqual(sut.imageURL, nil)
        XCTAssertEqual(sut.checkPrice, .zero)
        XCTAssertEqual(sut.currentPrice, "$0.00")
        XCTAssertEqual(sut.priceChangePercentage24h, "0.00")
        XCTAssertEqual(sut.rank, "Rank: N/A")
        XCTAssertEqual(sut.homepageLink, "N/A")
        XCTAssertEqual(sut.high24h, "0.00")
        XCTAssertEqual(sut.low24h, "0.00")
        
        sut.fetchCryptoDetail()
        sut.onCryptoDetailChange
            .sink(receiveValue: { _ in
                XCTAssertTrue(sut.imageURL != nil)
                XCTAssertTrue(sut.checkPrice != .zero)
                XCTAssertTrue(sut.currentPrice != "$0.00")
                XCTAssertTrue(sut.priceChangePercentage24h != "0.00")
                XCTAssertTrue(sut.rank != "Rank: N/A")
                XCTAssertTrue(sut.homepageLink != "N/A")
                XCTAssertTrue(sut.high24h != "0.00")
                XCTAssertTrue(sut.low24h != "0.00")
                expectCalled.fulfill()
            }).store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
    }
    
    func test_fetch_detail_successfully2() throws {
        Resolver.registerMockServices_success_2()
        let sut = CryptoDetailVM(entity: cryptoDetailEntity)
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getSymbol(), "\(cryptoDetailEntity.symbol.uppercased())/USD")
        XCTAssertEqual(sut.imageURL, nil)
        XCTAssertEqual(sut.checkPrice, .zero)
        XCTAssertEqual(sut.currentPrice, "$0.00")
        XCTAssertEqual(sut.priceChangePercentage24h, "0.00")
        XCTAssertEqual(sut.rank, "Rank: N/A")
        XCTAssertEqual(sut.homepageLink, "N/A")
        XCTAssertEqual(sut.high24h, "0.00")
        XCTAssertEqual(sut.low24h, "0.00")

        sut.fetchCryptoDetail()
        sut.onCryptoDetailChange
            .sink(receiveValue: { _ in
                XCTAssertTrue(sut.imageURL != nil)
                XCTAssertTrue(sut.checkPrice != .zero)
                XCTAssertTrue(sut.currentPrice != "$0.00")
                XCTAssertTrue(sut.priceChangePercentage24h != "0.00")
                XCTAssertTrue(sut.rank != "Rank: N/A")
                XCTAssertTrue(sut.homepageLink == "N/A")
                XCTAssertTrue(sut.high24h != "0.00")
                XCTAssertTrue(sut.low24h != "0.00")
                expectCalled.fulfill()
            }).store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
    }
    
    func test_fetch_detail_successfully3() throws {
        Resolver.registerMockServices_success_3()
        let sut = CryptoDetailVM(entity: cryptoDetailEntity)
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getSymbol(), "\(cryptoDetailEntity.symbol.uppercased())/USD")
        XCTAssertEqual(sut.imageURL, nil)
        XCTAssertEqual(sut.checkPrice, .zero)
        XCTAssertEqual(sut.currentPrice, "$0.00")
        XCTAssertEqual(sut.priceChangePercentage24h, "0.00")
        XCTAssertEqual(sut.rank, "Rank: N/A")
        XCTAssertEqual(sut.homepageLink, "N/A")
        XCTAssertEqual(sut.high24h, "0.00")
        XCTAssertEqual(sut.low24h, "0.00")

        sut.fetchCryptoDetail()
        sut.onCryptoDetailChange
            .sink(receiveValue: { _ in
                XCTAssertTrue(sut.imageURL != nil)
                XCTAssertTrue(sut.checkPrice != .zero)
                XCTAssertTrue(sut.currentPrice != "$0.00")
                XCTAssertTrue(sut.priceChangePercentage24h != "0.00")
                XCTAssertTrue(sut.rank != "Rank: N/A")
                XCTAssertTrue(sut.homepageLink != "N/A")
                XCTAssertTrue(sut.high24h != "0.00")
                XCTAssertTrue(sut.low24h != "0.00")
                expectCalled.fulfill()
            }).store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
    }
    
    func test_fetch_detail_failed() throws {
        Resolver.registerMockServices_failed()
        let sut = CryptoDetailVM(entity: cryptoDetailEntity)
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getSymbol(), "\(cryptoDetailEntity.symbol.uppercased())/USD")
        XCTAssertEqual(sut.imageURL, nil)
        XCTAssertEqual(sut.checkPrice, .zero)
        XCTAssertEqual(sut.currentPrice, "$0.00")
        XCTAssertEqual(sut.priceChangePercentage24h, "0.00")
        XCTAssertEqual(sut.rank, "Rank: N/A")
        XCTAssertEqual(sut.homepageLink, "N/A")
        XCTAssertEqual(sut.high24h, "0.00")
        XCTAssertEqual(sut.low24h, "0.00")

        sut.fetchCryptoDetail()
        sut.onCryptoDetailChange
            .sink(receiveValue: { _ in
                expectCalled.fulfill()
            }).store(in: &subscriptions)
        
        let result = XCTWaiter.wait(for: [expectCalled], timeout: 0.1)
        XCTAssertEqual(result, .timedOut)
    }

}
