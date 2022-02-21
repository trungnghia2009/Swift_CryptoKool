//
//  CryptoSearchEntity.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation

struct CryptoSearchEntity: Equatable {
    let id: String
    let symbol: String
    let name: String
    let rank: Int?
    let imageURL: String?
}
