//
//  QueryLink.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct QueryLink {
    static let shared = QueryLink()
    private init() {}
    
    func getCryptoList(amount: Int) -> String {
        return "https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&order=market_cap_desc&per_page=\(amount)&page=1&sparkline=false"
    }
    
    func getSearch(keyword: String) -> String {
        return "https://api.coingecko.com/api/v3/search?query=\(keyword)"
    }
    
    func getCryptoDetail(id: String) -> String {
        return "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false"
    }
}
