//
//  QueryLink.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct QueryLink {
    static let shared = QueryLink()
    
    private let baseURL = "https://api.coingecko.com/api/v3/"
    
    private init() {}
    
    func getCryptoList(amount: Int) -> String {
        return "\(baseURL)coins/markets?vs_currency=USD&order=market_cap_desc&per_page=\(amount)&page=1&sparkline=false"
    }
    
    func getSearch(keyword: String) -> String {
        return "\(baseURL)search?query=\(keyword)".replacingOccurrences(of: " ", with: "%20")
    }
    
    func getCryptoDetail(id: String) -> String {
        return "\(baseURL)coins/\(id)?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false"
    }
}
