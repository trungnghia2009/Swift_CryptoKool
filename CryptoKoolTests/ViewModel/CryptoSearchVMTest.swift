//
//  CryptoSearchVMTest.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

import XCTest
import Combine
@testable import CryptoKool

class CryptoSearchVMTest: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()
    
    func test_search_successfully() throws {
        Resolver.registerMockServices_success_1()
        let sut = CryptoSearchVM()
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getCryptoList().count, 0)
        XCTAssertTrue(sut.getState() == .begin)
        
        sut.searchCrypto(searchKey: "doge")
        sut.state
            .dropFirst(1)
            .sink { _ in
                XCTAssertEqual(sut.getState(), .done)
                expectCalled.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
        
        let searchCount = sut.getCryptoList().count
        let searchList = sut.getCryptoList()
        
        XCTAssertEqual(searchCount, 25)
        for i in 0..<searchCount {
            XCTAssertTrue(sut.cryptoAtIndex(i) == searchList[i])
        }
        
        let cell = CryptoSearchCell()
        for i in 0..<searchList.count {
            let cryptoSearchCellVM = CryptoSearchCellVM(crypto: searchList[i])
            cell.viewModel = cryptoSearchCellVM
            
            // Test CryptoDetailVM
            let cryptoDetailEntity = searchList[i].mapToDetailEntity()
            let cryptoDetailVM = CryptoDetailVM(entity: cryptoDetailEntity)
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
    }
    
    func test_search_with_empty_keyword() throws {
        Resolver.registerMockServices_success_1()
        let sut = CryptoSearchVM()
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getCryptoList().count, 0)
        XCTAssertTrue(sut.getState() == .begin)
        
        sut.searchCrypto(searchKey: "")
        sut.state
            .sink { _ in
                XCTAssertEqual(sut.getState(), .begin)
                expectCalled.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
    }
    
    func test_search_with_no_data() throws {
        Resolver.registerMockServices_search_no_data()
        let sut = CryptoSearchVM()
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getCryptoList().count, 0)
        XCTAssertTrue(sut.getState() == .begin)
        
        sut.searchCrypto(searchKey: "xxxxxx")
        sut.state
            .dropFirst(1)
            .sink { _ in
                XCTAssertEqual(sut.getState(), .noResult)
                expectCalled.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
    }
    
    func test_search_data_failed() throws {
        Resolver.registerMockServices_search_failed()
        let sut = CryptoSearchVM()
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getCryptoList().count, 0)
        XCTAssertTrue(sut.getState() == .begin)
        
        sut.searchCrypto(searchKey: "fail for sure")
        sut.state
            .sink { _ in
                XCTAssertEqual(sut.getState(), .loading)
                expectCalled.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
    }

}
