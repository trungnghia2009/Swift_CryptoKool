//
//  CryptoEntity.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct CryptoEntity {
    let id: String
    let symbol: String
    let name: String
    let rank: Int?
    let imageURL: String?
    let currentPrice: Double?
    let priceChangePercentage24h: Double?
}
