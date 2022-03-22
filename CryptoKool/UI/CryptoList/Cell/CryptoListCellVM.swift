//
//  CryptoVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

enum Percentage24hState {
    case increasing
    case decreasing
    case zero
}

final class CryptoListCellVM {
    
    private let crypto: CryptoEntity
    
    init(crypto: CryptoEntity) {
        self.crypto = crypto
    }
    
    var cryptoName: String {
        return "\(crypto.name) (\(crypto.symbol.uppercased()))"
    }
    
    var rank: String {
        guard let capRank = crypto.rank else {
            return "Rank: N/A"
        }
        return "Rank: \(String(capRank))"
    }
    
    var imageURL: String? {
        return crypto.imageURL
    }
    
    var checkPrice: Percentage24hState {
        guard let price = crypto.priceChangePercentage24h else {
            return .zero
        }
        return price > 0 ? .increasing : .decreasing
    }
    
    var currentPrice: String {
        guard let price = crypto.currentPrice else {
            return "$0.00"
        }
        
        if price < 0.0099 {
            return "$\(String(format: "%.8f", price))"
        }
        if price < 100000 {
            return "$\(String(format: "%.2f", price))"
        }
        return "$\(String(format: "%.0f", price))"
    }
    
    var priceChangePercentage24h: String {
        guard let price = crypto.priceChangePercentage24h else {
            return "0.00"
        }
        
        if price > 0 {
            return "+\(String(format: "%.2f", price))" + "%"
        }
        return "\(String(format: "%.2f", price))" + "%"
    }
}
