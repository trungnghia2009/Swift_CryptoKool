//
//  MockCoinGeckoAPI+NoData.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

@testable import CryptoKool
import Combine

class MockCongeckoAPI_NoData: CoinGeckoInterface {
    func fetchCryptoList(amount: Int) -> AnyPublisher<[CryptoEntity], Error> {
        return Future<[CryptoEntity], Error> { promise in
            promise(.failure(CoinGeckoServiceError.apiError(reason: "Unknow error")))
        }.eraseToAnyPublisher()
    }
    
    func fetchCryptoDetail(id: String) -> AnyPublisher<CryptoDetailEntity, Error> {
        return Future<CryptoDetailEntity, Error> { promise in
            promise(.failure(CoinGeckoServiceError.apiError(reason: "Unknow error")))
        }.eraseToAnyPublisher()
    }
    
    func searchCrypto(keyword: String) -> AnyPublisher<[CryptoSearchEntity], Error> {
        return Future<[CryptoSearchEntity], Error> { promise in
            promise(.success([CryptoSearchEntity]()))
        }.eraseToAnyPublisher()
    }
}

