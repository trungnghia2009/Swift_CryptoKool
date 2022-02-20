//
//  CryptoSearchResponse.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct CryptoSearchResponse: Decodable {
    let coins: [SearchCrypto]
    
    struct SearchCrypto: Decodable {
        let id: String
        let name: String
        let symbol: String
        let rank: Int?
        let imageURL: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case symbol = "symbol"
            case rank = "market_cap_rank"
            case imageURL = "large"
        }
    }
}
