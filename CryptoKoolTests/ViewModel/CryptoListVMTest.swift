//
//  CryptoKoolTests.swift
//  CryptoKoolTests
//
//  Created by trungnghia on 18/02/2022.
//

import XCTest
import Combine
@testable import CryptoKool

class CryptoListVMTest: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()

    func test_fetch_data_successfully() throws {
        Resolver.registerMockServices_success_1()
        let sut = CryptoListVM()
        let expectCalled = expectation(description: "Contains Network response")
        
        sut.fetchCryptoList()
        sut.onCryptoListChange
            .sink { _ in
                XCTAssertEqual(sut.getCryptoList().count, 100)
                expectCalled.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
        
        let cryptoList = sut.getCryptoList()
        for i in 0..<cryptoList.count {
            XCTAssertEqual(sut.cryptoAtIndex(i), cryptoList[i])
        }

        let cell = CryptoListCell()
        for i in 0..<cryptoList.count {
            let cryptoListCellVM = CryptoListCellVM(crypto: cryptoList[i])
            cell.viewModel = cryptoListCellVM

            // Test CryptoDetailVM
            let cryptoDetailEntity = cryptoList[i].mapToDetailEntity()
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
    
    func test_coreData_fetch() throws {
        Resolver.registerMockServices_success_1()
        let sut = CryptoListVM()
        let expectCalled = expectation(description:"CoreData")
        
        let cryptoList: [CryptoEntity] = [
        CryptoEntity(id: "1",
                     symbol: "x1",
                     name: "coin1",
                     rank: 1,
                     imageURL: "image1",
                     currentPrice: 10.0,
                     priceChangePercentage24h: 20.0),
        CryptoEntity(id: "2",
                     symbol: "x2",
                     name: "coint2",
                     rank: 2,
                     imageURL: "image2",
                     currentPrice: 10.4,
                     priceChangePercentage24h: 24.9),
        CryptoEntity(id: "3",
                     symbol: "x3",
                     name: "coin3",
                     rank: 3,
                     imageURL: "image3",
                     currentPrice: 10.5,
                     priceChangePercentage24h: 30.0)
        ]
        
        sut.saveData(list: cryptoList)
        sut.firstFetchFromDataBase()
        sut.onCryptoListChange
            .sink { _ in
                XCTAssertEqual(sut.getCryptoList().count, 3)
                expectCalled.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
    }
    
    func test_fetch_data_failed() throws {
        Resolver.registerMockServices_failed()
        let sut = CryptoListVM()
        let expectCalled = expectation(description: "Contains Network response")
        
        XCTAssertEqual(sut.getCryptoList().count, 0)
        sut.fetchCryptoList()
        sut.onError
            .sink { error in
                XCTAssertEqual(error.description, "Unknow error")
                expectCalled.fulfill()
            }.store(in: &subscriptions)
        
        wait(for: [expectCalled], timeout: 0.1)
        
    }

}
