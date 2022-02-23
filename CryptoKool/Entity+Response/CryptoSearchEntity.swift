//
//  CryptoSearchEntity.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct CryptoSearchEntity: Equatable {
    let id: String
    let symbol: String
    let name: String
    let rank: Int?
    let imageURL: String?
    
    func mapToDetailEntity() -> CryptoDetailEntity {
        let cryptoDetailEntity = CryptoDetailEntity(id: self.id,
                                                    symbol: self.symbol,
                                                    name: self.name,
                                                    imageURL: nil,
                                                    homePage: [String](),
                                                    currentPrice: nil,
                                                    priceChangePercentage24h: nil,
                                                    rank: self.rank,
                                                    high24h: nil,
                                                    low24h: nil,
                                                    marketCap: nil)
        return cryptoDetailEntity
    }
}
