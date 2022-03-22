//
//  CryptoDetailResponse.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct CryptoDetailResponse: Decodable {
    let id: String
    let symbol: String
    let name: String
    let imageURL: Image
    let links: Links
    let marketData: MarketData // for getting price
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case imageURL = "image"
        case links = "links"
        case marketData = "market_data"
    }
    
    struct Image: Decodable {
        let large: String?
    }
    
    struct Links: Decodable {
        let homepage: [String]
    }
    
    struct MarketData: Decodable {
        let currentPrice: CurrentPrice?
        let marketCap: MarketCap?
        let rank: Int?
        let priceChangePercentage24h: Double?
        let high24h: High24h?
        let low24h: Low24h?
        
        enum CodingKeys: String, CodingKey {
            case currentPrice = "current_price"
            case marketCap = "market_cap"
            case rank = "market_cap_rank"
            case priceChangePercentage24h = "price_change_percentage_24h"
            case high24h = "high_24h"
            case low24h = "low_24h"
        }
        
        struct CurrentPrice: Decodable {
            let usd: Double?
        }
        
        struct MarketCap: Decodable {
            let usd: Double?
        }
        
        struct High24h: Decodable {
            let usd: Double?
        }
        
        struct Low24h: Decodable {
            let usd: Double?
        }
    }
}
