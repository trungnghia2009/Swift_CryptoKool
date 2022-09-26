//
//  CryptpService.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

protocol CryptoServiceInterface: AnyObject {
    func fetchCryptoList(amount: Int) -> AnyPublisher<[CryptoEntity], Error>
    func fetchCryptoDetail(id: String) -> AnyPublisher<CryptoDetailEntity, Error>
    func searchCrypto(keyword: String) -> AnyPublisher<[CryptoSearchEntity], Error>
}

final class CryptoService: CryptoServiceInterface {

    var coinGeckoService: CoinGeckoInterface
    
    init(coinGeckoService: CoinGeckoInterface) {
        self.coinGeckoService = coinGeckoService
    }
    
    func fetchCryptoList(amount: Int) -> AnyPublisher<[CryptoEntity], Error> {
        coinGeckoService.fetchCryptoList(amount: amount)
    }
    
    func fetchCryptoDetail(id: String) -> AnyPublisher<CryptoDetailEntity, Error> {
        coinGeckoService.fetchCryptoDetail(id: id)
    }
    
    func searchCrypto(keyword: String) -> AnyPublisher<[CryptoSearchEntity], Error> {
        coinGeckoService.searchCrypto(keyword: keyword)
    }
}
