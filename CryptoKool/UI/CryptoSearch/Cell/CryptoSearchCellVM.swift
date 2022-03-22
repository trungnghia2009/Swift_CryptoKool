//
//  CryptoSearchCellVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

final class CryptoSearchCellVM {
    
    private let crypto: CryptoSearchEntity
    
    init(crypto: CryptoSearchEntity) {
        self.crypto = crypto
    }
    
    var cryptoName: String {
        return "\(crypto.name) (\(crypto.symbol))"
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
}
