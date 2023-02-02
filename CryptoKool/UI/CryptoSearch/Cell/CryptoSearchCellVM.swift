//
//  CryptoSearchCellVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

final class CryptoSearchCellVM {
    
    private let crypto: CryptoSearchEntity
    private let _imageRepository: ImageRepositoryProtocol
    
    init(crypto: CryptoSearchEntity, imageRepository: ImageRepositoryProtocol = ImageRepository()) {
        self.crypto = crypto
        self._imageRepository = imageRepository
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
    
    var imageRepository: ImageRepositoryProtocol {
        return _imageRepository
    }
}
