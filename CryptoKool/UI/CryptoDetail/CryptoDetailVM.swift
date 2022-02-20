//
//  CryptoDetailVM.swift
//  CryptoKool
//
//  Created by trungnghia on 20/02/2022.
//

import Foundation
import ReactiveSwift

final class CryptoDetailVM {
    
    private let service: CryptoServiceInterface
    private(set) var cryptoDetail = MutableProperty<CryptoDetailEntity?>(nil)
    
    init(service: CryptoServiceInterface) {
        self.service = service
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoDetailVM...")
    }
    
    func fetchCryptoDetail(id: String) {
        let useCase = FetchCryptoDetailUseCase(service: service)
        useCase.execute(param: id)
            .observe(on: UIScheduler())
            .startWithResult { [weak self] result in
                switch result {
                case .success(let detail):
                    CKLog.info(message: "Got detail successfully: \(detail)")
                    self?.cryptoDetail.value = detail
                case .failure(let error):
                    CKLog.error(message: "Got error: \(error)")
                }
            }
    }
    
    private func parsePrice(price: Double) -> String {
        if price < 0.0099 {
            return "$\(String(format: "%.8f", price))"
        } else if price < 100000 {
            return "$\(String(format: "%.2f", price))"
        } else {
            return "$\(String(format: "%.0f", price))"
        }
    }
    
    var imageURL: String? {
        return cryptoDetail.value?.imageURL
    }
    
    var checkPrice: Percentage24hState {
        guard let price = cryptoDetail.value?.priceChangePercentage24h else {
            return .zero
        }
        return price > 0 ? .increasing : .decreasing
    }
    
    var currentPrice: String {
        guard let price = cryptoDetail.value?.currentPrice else {
            return "$0.00"
        }
        return parsePrice(price: price)
    }
    
    var priceChangePercentage24h: String {
        guard let price = cryptoDetail.value?.priceChangePercentage24h else {
            return "0.00"
        }
        if price > 0 {
            return "+\(String(format: "%.2f", price))" + "%"
        } else {
            return "\(String(format: "%.2f", price))" + "%"
        }
    }
    
    var rank: String {
        guard let capRank = cryptoDetail.value?.rank else {
            return "Rank: N/A"
        }
        return "Rank: \(String(capRank))"
    }
    
    var homepageLink: String {
        guard let homepage = cryptoDetail.value?.homePage else {
            return "N/A"
        }
        
        let finalhomePage = homepage.filter { !$0.isEmpty }
        return finalhomePage.first ?? "N/A"
    }
    
    var high24h: String? {
        guard let price = cryptoDetail.value?.high24h else {
            return "0.00"
        }
        return parsePrice(price: price)
    }
    
    var low24h: String? {
        guard let price = cryptoDetail.value?.low24h else {
            return "0.00"
        }
        return parsePrice(price: price)
    }
    
}

