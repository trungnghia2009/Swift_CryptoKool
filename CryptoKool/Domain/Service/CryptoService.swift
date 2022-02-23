//
//  CryptpService.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import ReactiveSwift

protocol CryptoServiceInterface: AnyObject {
    func fetchCryptoList(amount: Int) -> SignalProducer<[CryptoEntity], Error>
    func fetchCryptoDetail(id: String) -> SignalProducer<CryptoDetailEntity, Error>
    func searchCrypto(keyword: String) -> SignalProducer<[CryptoSearchEntity], Error>
}

final class CryptoService: CryptoServiceInterface {

    var coinGeckoService: CoinGeckoInterface
    
    init(coinGeckoService: CoinGeckoInterface) {
        self.coinGeckoService = coinGeckoService
    }
    
    func fetchCryptoList(amount: Int) -> SignalProducer<[CryptoEntity], Error> {
        coinGeckoService.fetchCryptoList(amount: amount)
    }
    
    func fetchCryptoDetail(id: String) -> SignalProducer<CryptoDetailEntity, Error> {
        coinGeckoService.fetchCryptoDetail(id: id)
    }
    
    func searchCrypto(keyword: String) -> SignalProducer<[CryptoSearchEntity], Error> {
        coinGeckoService.searchCrypto(keyword: keyword)
    }
}
