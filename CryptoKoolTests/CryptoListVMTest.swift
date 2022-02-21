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
        let sut = CryptoListVM(service: CrytoService(coinGeckoService: MockCongeckoAPI_Success()))

        XCTAssertTrue(sut.numberOfRowsInSection(0) == 0)
        sut.fetchCryptoList(amount: 100)
        XCTAssertTrue(sut.numberOfRowsInSection(0) == 100)
        let cryptoList = sut.cryptoList.value
        for i in 0..<cryptoList.count {
            XCTAssertTrue(sut.cryptoAtIndex(i) == cryptoList[i])
        }
        
        let cell = CryptoListCell()
        for i in 0..<cryptoList.count {
            let cryptoListCellVM = CryptoListCellVM(crpto: cryptoList[i])
            cell.viewModel = cryptoListCellVM
        }
    }
    
    func test_fetch_data_failed() throws {
        let sut = CryptoListVM(service: CrytoService(coinGeckoService: MockCongeckoAPI_Fail()))

        XCTAssertTrue(sut.numberOfRowsInSection(0) == 0)
        sut.fetchCryptoList(amount: 100)
        XCTAssertTrue(sut.numberOfRowsInSection(0) == 0)
        
    }

}
