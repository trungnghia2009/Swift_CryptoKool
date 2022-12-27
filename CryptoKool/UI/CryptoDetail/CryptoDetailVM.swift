//
//  CryptoDetailVM.swift
//  CryptoKool
//
//  Created by trungnghia on 20/02/2022.
//

import Foundation
import Combine

final class CryptoDetailVM {
    
    @Injected private var service: CryptoServiceInterface
    
    private let entity: CryptoDetailEntity
    private var subscriptions = Set<AnyCancellable>()
    
    private let cryptoDetailSubject = CurrentValueSubject<CryptoDetailEntity?, Never>(nil)
    var onCryptoDetailChange: AnyPublisher<Void, Never> {
        return cryptoDetailSubject
            .map { detail -> Void in }
            .dropFirst(1) // drop nil value
            .eraseToAnyPublisher()
    }
    
    init(entity: CryptoDetailEntity) {
        self.entity = entity
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoDetailVM...")
    }
    
    func fetchCryptoDetail() {
        let useCase = FetchCryptoDetailUseCase(service: service)
        useCase.execute(param: entity.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    CKLog.error(message: "Retrieving data with error: \(error)")
                }
            } receiveValue: { [weak self] crypto in
                CKLog.info(message: "Got detail successfully: \(crypto)")
                self?.cryptoDetailSubject.send(crypto)
            }.store(in: &subscriptions)
    }
    
    func getSymbol() -> String {
        return "\(entity.symbol.uppercased())/USD"
    }
    
    private func parsePrice(price: Double) -> String {
        CKLog.info(message: "Price is :\(price)")
        if price < 0.0099 {
            return "$\(String(format: "%.8f", price))"
        }
        if price < 100000 {
            return "$\(String(format: "%.2f", price))"
        }
        return "$\(String(format: "%.0f", price))"
    }
    
    var imageURL: String? {
        return cryptoDetailSubject.value?.imageURL
    }
    
    var checkPrice: Percentage24hState {
        guard let price = cryptoDetailSubject.value?.priceChangePercentage24h else {
            return .zero
        }
        return price > 0 ? .increasing : .decreasing
    }
    
    var currentPrice: String {
        guard let price = cryptoDetailSubject.value?.currentPrice else {
            return "$0.00"
        }
        return parsePrice(price: price)
    }
    
    var priceChangePercentage24h: String {
        guard let price = cryptoDetailSubject.value?.priceChangePercentage24h else {
            return "0.00"
        }
        if price > 0 {
            return "+\(String(format: "%.2f", price))" + "%"
        }
        return "\(String(format: "%.2f", price))" + "%"
        
    }
    
    var rank: String {
        guard let capRank = cryptoDetailSubject.value?.rank else {
            return "Rank: N/A"
        }
        return "Rank: #\(String(capRank))"
    }
    
    var homepageLink: String {
        guard let homepage = cryptoDetailSubject.value?.homePage else {
            return "N/A"
        }
        
        let finalHomePage = homepage.filter { !$0.isEmpty }
        return finalHomePage.first ?? "N/A"
    }
    
    var high24h: String? {
        guard let price = cryptoDetailSubject.value?.high24h else {
            return "0.00"
        }
        return parsePrice(price: price)
    }
    
    var low24h: String? {
        guard let price = cryptoDetailSubject.value?.low24h else {
            return "0.00"
        }
        return parsePrice(price: price)
    }
}
