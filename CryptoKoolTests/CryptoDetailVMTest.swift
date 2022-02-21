//
//  CryptoDetailVMTest.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

import XCTest
@testable import CryptoKool

class CryptoDetailVMTest: XCTestCase {

    func test_fetch_detail_successfully() throws {
        let sut = CryptoDetailVM(service: CrytoService(coinGeckoService: MockCongeckoAPI_Success()))
        XCTAssertTrue(sut.imageURL == nil)
        XCTAssertTrue(sut.checkPrice == .zero)
        XCTAssertTrue(sut.currentPrice == "$0.00")
        XCTAssertTrue(sut.priceChangePercentage24h == "0.00")
        XCTAssertTrue(sut.rank == "Rank: N/A")
        XCTAssertTrue(sut.homepageLink == "N/A")
        XCTAssertTrue(sut.high24h == "0.00")
        XCTAssertTrue(sut.low24h == "0.00")
        
        sut.fetchCryptoDetail(id: "ethereum")
        XCTAssertTrue(sut.imageURL != nil)
        XCTAssertTrue(sut.checkPrice != .zero)
        XCTAssertTrue(sut.currentPrice != "$0.00")
        XCTAssertTrue(sut.priceChangePercentage24h != "0.00")
        XCTAssertTrue(sut.rank != "Rank: N/A")
        XCTAssertTrue(sut.homepageLink != "N/A")
        XCTAssertTrue(sut.high24h != "0.00")
        XCTAssertTrue(sut.low24h != "0.00")
    }
    
    func test_fetch_detail_failed() throws {
        let sut = CryptoDetailVM(service: CrytoService(coinGeckoService: MockCongeckoAPI_Fail()))
        XCTAssertTrue(sut.imageURL == nil)
        XCTAssertTrue(sut.checkPrice == .zero)
        XCTAssertTrue(sut.currentPrice == "$0.00")
        XCTAssertTrue(sut.priceChangePercentage24h == "0.00")
        XCTAssertTrue(sut.rank == "Rank: N/A")
        XCTAssertTrue(sut.homepageLink == "N/A")
        XCTAssertTrue(sut.high24h == "0.00")
        XCTAssertTrue(sut.low24h == "0.00")
        
        sut.fetchCryptoDetail(id: "ethereum")
        XCTAssertTrue(sut.imageURL == nil)
        XCTAssertTrue(sut.checkPrice == .zero)
        XCTAssertTrue(sut.currentPrice == "$0.00")
        XCTAssertTrue(sut.priceChangePercentage24h == "0.00")
        XCTAssertTrue(sut.rank == "Rank: N/A")
        XCTAssertTrue(sut.homepageLink == "N/A")
        XCTAssertTrue(sut.high24h == "0.00")
        XCTAssertTrue(sut.low24h == "0.00")
    }

}
