//
//  CryptoListResponse.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct CryptoResponse: Decodable {
    let id: String
    let symbol: String
    let name: String
    let rank: Int?
    let image: String?
    let currentPrice: Double?
    let priceChangePercentage24h: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case rank = "market_cap_rank"
        case image = "image"
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}
