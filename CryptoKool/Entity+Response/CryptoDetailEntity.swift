//
//  CryptoDetailEntity.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct CryptoDetailEntity {
    let id: String
    let symbol: String
    let name: String
    let imageURL: String?
    let homePage: [String]
    let currentPrice: Double?
    let priceChangePercentage24h: Double?
    let rank: Int?
    let high24h: Double?
    let low24h: Double?
    let marketCap: Double?
}
