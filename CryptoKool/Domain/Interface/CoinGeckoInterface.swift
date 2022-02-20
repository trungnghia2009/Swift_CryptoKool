//
//  CoinGeckoInterface.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import ReactiveSwift

protocol CoinGeckoInterface: AnyObject {
    func fetchCryptoList(amount: Int) -> SignalProducer<[CryptoEntity], Error>
    func fetchCryptoDetail(id: String) -> SignalProducer<CryptoDetailEntity, Error>
    func searchCrypto(keyword: String) -> SignalProducer<[CryptoSearchEntity], Error>
}
