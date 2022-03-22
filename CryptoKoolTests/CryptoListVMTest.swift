//
//  CryptoKoolTests.swift
//  CryptoKoolTests
//
//  Created by trungnghia on 18/02/2022.
//

import XCTest
@testable import CryptoKool

class CryptoListVMTest: XCTestCase {

    func test_fetch_data_successfully() throws {
        let service: CryptoServiceInterface = CryptoService(coinGeckoService: MockCongeckoAPI_Success1())
        let sut = CryptoListVM(service: service)

        XCTAssertEqual(sut.numberOfRowsInSection(0), 0)
        sut.fetchCryptoList()
        XCTAssertEqual(sut.numberOfRowsInSection(0), 100)
        let cryptoList = sut.cryptoList.value
        for i in 0..<cryptoList.count {
            XCTAssertEqual(sut.cryptoAtIndex(i), cryptoList[i])
        }
        
        let cell = CryptoListCell()
        for i in 0..<cryptoList.count {
            let cryptoListCellVM = CryptoListCellVM(crypto: cryptoList[i])
            cell.viewModel = cryptoListCellVM
            
            // Test CryptoDetailVM
            let cryptoDetailEntity = cryptoList[i].mapToDetailEntity()
            let cryptoDetailVM = CryptoDetailVM(service: service, entity: cryptoDetailEntity)
            
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
    
    func test_fetch_data_failed() throws {
        let sut = CryptoListVM(service: CryptoService(coinGeckoService: MockCongeckoAPI_Fail()))

        XCTAssertEqual(sut.numberOfRowsInSection(0), 0)
        sut.fetchCryptoList()
        XCTAssertEqual(sut.numberOfRowsInSection(0), 0)
        
    }

}
