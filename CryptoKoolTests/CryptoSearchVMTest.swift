//
//  CryptoSearchVMTest.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

import XCTest
@testable import CryptoKool

class CryptoSearchVMTest: XCTestCase {

    func test_search_successfully_then_delete_keyword() throws {
        let service: CryptoServiceInterface = CryptoService(coinGeckoService: MockCongeckoAPI_Success1())
        let sut = CryptoSearchVM(service: service)
        
        XCTAssertTrue(sut.numberOfRowsInSection(0) == 0)
        XCTAssertTrue(sut.getState() == .begin)
        
        sut.searchCrypto(searchKey: "doge")
        XCTAssertTrue(sut.getState() == .done)
        
        let searchCount = sut.numberOfRowsInSection(0)
        let searchList = sut.searchList
        
        XCTAssertTrue(searchCount > 0)
        for i in 0..<searchCount {
            XCTAssertTrue(sut.cryptoAtIndex(i) == sut.searchList[i])
        }
        
        let cell = CryptoSearchCell()
        for i in 0..<searchList.count {
            let cryptoSearchCellVM = CryptoSearchCellVM(crypto: searchList[i])
            cell.viewModel = cryptoSearchCellVM
            
            // Test CryptoDetailVM
            let cryptoDetailEntity = searchList[i].mapToDetailEntity()
            let cryptoDetailVM = CryptoDetailVM(service: sut.getService(), entity: cryptoDetailEntity)
            XCTAssertEqual(cryptoDetailVM.getSymbol(), "\(cryptoDetailEntity.symbol.uppercased())/USD")
            XCTAssertEqual(cryptoDetailVM.imageURL, nil)
            XCTAssertEqual(cryptoDetailVM.checkPrice, .zero)
            XCTAssertEqual(cryptoDetailVM.currentPrice, "$0.00")
            XCTAssertEqual(cryptoDetailVM.priceChangePercentage24h, "0.00")
            XCTAssertEqual(cryptoDetailVM.rank, "Rank: N/A")
            XCTAssertEqual(cryptoDetailVM.homepageLink, "N/A")
            XCTAssertEqual(cryptoDetailVM.high24h, "0.00")
            XCTAssertEqual(cryptoDetailVM.low24h, "0.00")
        }
        
        sut.searchCrypto(searchKey: "")
        XCTAssertTrue(sut.numberOfRowsInSection(0) == 0)
        XCTAssertTrue(sut.getState() == .begin)
    }
    
    func test_search_with_no_data() throws {
        let sut = CryptoSearchVM(service: CryptoService(coinGeckoService: MockCongeckoAPI_NoData()))
        XCTAssertTrue(sut.numberOfRowsInSection(0) == 0)
        XCTAssertTrue(sut.getState() == .begin)
        sut.searchCrypto(searchKey: "xxxxxx")
        XCTAssertTrue(sut.getState() == .noResult)
    }
    
    func test_search_data_failed() throws {
        let sut = CryptoSearchVM(service: CryptoService(coinGeckoService: MockCongeckoAPI_Fail()))
        XCTAssertTrue(sut.numberOfRowsInSection(0) == 0)
        XCTAssertTrue(sut.getState() == .begin)
        sut.searchCrypto(searchKey: "fail for sure")
        XCTAssertTrue(sut.numberOfRowsInSection(0) == 0)
        XCTAssertTrue(sut.getState() == .loading)
    }

}
