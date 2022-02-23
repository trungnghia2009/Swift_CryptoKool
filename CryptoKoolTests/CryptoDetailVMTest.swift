//
//  CryptoDetailVMTest.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

import XCTest
@testable import CryptoKool

class CryptoDetailVMTest: XCTestCase {
    
    let cryptoDetailEntity = CryptoDetailEntity(id: "id",
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
        let service: CryptoServiceInterface = CryptoService(coinGeckoService: MockCongeckoAPI_Success1())
        let sut = CryptoDetailVM(service: service, entity: cryptoDetailEntity)
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
        XCTAssertTrue(sut.imageURL != nil)
        XCTAssertTrue(sut.checkPrice != .zero)
        XCTAssertTrue(sut.currentPrice != "$0.00")
        XCTAssertTrue(sut.priceChangePercentage24h != "0.00")
        XCTAssertTrue(sut.rank != "Rank: N/A")
        XCTAssertTrue(sut.homepageLink != "N/A")
        XCTAssertTrue(sut.high24h != "0.00")
        XCTAssertTrue(sut.low24h != "0.00")
    }
    
    func test_fetch_detail_successfully2() throws {
        let service: CryptoServiceInterface = CryptoService(coinGeckoService: MockCongeckoAPI_Success2())
        let sut = CryptoDetailVM(service: service, entity: cryptoDetailEntity)
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
        XCTAssertTrue(sut.imageURL != nil)
        XCTAssertTrue(sut.checkPrice != .zero)
        XCTAssertTrue(sut.currentPrice != "$0.00")
        XCTAssertTrue(sut.priceChangePercentage24h != "0.00")
        XCTAssertTrue(sut.rank != "Rank: N/A")
        XCTAssertTrue(sut.homepageLink == "N/A")
        XCTAssertTrue(sut.high24h != "0.00")
        XCTAssertTrue(sut.low24h != "0.00")
    }
    
    func test_fetch_detail_successfully3() throws {
        let service: CryptoServiceInterface = CryptoService(coinGeckoService: MockCongeckoAPI_Success3())
        let sut = CryptoDetailVM(service: service, entity: cryptoDetailEntity)
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
        let service: CryptoServiceInterface = CryptoService(coinGeckoService: MockCongeckoAPI_Fail())
        let sut = CryptoDetailVM(service: service, entity: cryptoDetailEntity)
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
        XCTAssertEqual(sut.imageURL, nil)
        XCTAssertEqual(sut.checkPrice, .zero)
        XCTAssertEqual(sut.currentPrice, "$0.00")
        XCTAssertEqual(sut.priceChangePercentage24h, "0.00")
        XCTAssertEqual(sut.rank, "Rank: N/A")
        XCTAssertEqual(sut.homepageLink, "N/A")
        XCTAssertEqual(sut.high24h, "0.00")
        XCTAssertEqual(sut.low24h, "0.00")
    }

}
