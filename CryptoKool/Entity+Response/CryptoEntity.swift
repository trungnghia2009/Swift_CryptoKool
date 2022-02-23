//
//  CryptoEntity.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct CryptoEntity: Equatable {
    let id: String
    let symbol: String
    let name: String
    let rank: Int?
    let imageURL: String?
    let currentPrice: Double?
    let priceChangePercentage24h: Double?
    
    func mapToDetailEntity() -> CryptoDetailEntity {
        let cryptoDetailEntity = CryptoDetailEntity(id: self.id,
                                                    symbol: self.symbol,
                                                    name: self.name,
                                                    imageURL: nil,
                                                    homePage: [String](),
                                                    currentPrice: self.currentPrice,
                                                    priceChangePercentage24h: self.priceChangePercentage24h,
                                                    rank: self.rank,
                                                    high24h: nil,
                                                    low24h: nil,
                                                    marketCap: nil)
        return cryptoDetailEntity
    }
}
