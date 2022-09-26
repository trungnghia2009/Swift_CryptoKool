//
//  CoinGeckoInterface.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

protocol CoinGeckoInterface: AnyObject {
    func fetchCryptoList(amount: Int) -> AnyPublisher<[CryptoEntity], Error>
    func fetchCryptoDetail(id: String) -> AnyPublisher<CryptoDetailEntity, Error>
    func searchCrypto(keyword: String) -> AnyPublisher<[CryptoSearchEntity], Error>
}
