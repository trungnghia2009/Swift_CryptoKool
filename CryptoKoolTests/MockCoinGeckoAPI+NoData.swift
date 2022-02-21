//
//  MockCoinGeckoAPI+NoData.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

@testable import CryptoKool
import ReactiveSwift

class MockCongeckoAPI_NoData: CoinGeckoInterface {
    func fetchCryptoList(amount: Int) -> SignalProducer<[CryptoEntity], Error> {
        return SignalProducer { observer, _ in
            observer.send(error: CoinGeckoServiceError.decodingError)
            observer.sendCompleted()
        }
    }
    
    func fetchCryptoDetail(id: String) -> SignalProducer<CryptoDetailEntity, Error> {
        return SignalProducer { observer, _ in
            observer.send(error: CoinGeckoServiceError.dataError)
            observer.sendCompleted()
        }
    }
    
    func searchCrypto(keyword: String) -> SignalProducer<[CryptoSearchEntity], Error> {
        return SignalProducer { observer, _ in
            observer.send(value: [CryptoSearchEntity]())
            observer.sendCompleted()
        }
    }
}

