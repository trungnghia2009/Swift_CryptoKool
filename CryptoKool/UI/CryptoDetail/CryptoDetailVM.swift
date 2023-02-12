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
    private let _imageRepository: ImageRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private let cryptoDetailSubject = CurrentValueSubject<CryptoDetailEntity?, Never>(nil)
    private let errorSubject = PassthroughSubject<CoinGeckoServiceError, Never>()
    
    var onCryptoDetailChange: AnyPublisher<Void, Never> {
        return cryptoDetailSubject
            .map { detail -> Void in }
            .dropFirst(1) // drop nil value
            .eraseToAnyPublisher()
    }
    var onError: AnyPublisher<CoinGeckoServiceError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    init(entity: CryptoDetailEntity, imageRepository: ImageRepositoryProtocol = ImageRepository()) {
        self.entity = entity
        self._imageRepository = imageRepository
    }
    
    deinit {
        CKLogger.info("Deinit CryptoDetailVM...")
    }
    
    func fetchCryptoDetail() {
        let useCase = FetchCryptoDetailUseCase(service: service)
        useCase.execute(param: entity.id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    CKLogger.info("FetchCryptoDetailUseCase completed...")
                case .failure(let error):
                    if let coinError = error as? CoinGeckoServiceError {
                        CKLogger.error("Error: \(coinError)")
                        self?.errorSubject.send(coinError)
                    }
                }
            } receiveValue: { [weak self] crypto in
                CKLogger.info("Got detail successfully: \(crypto)")
                self?.cryptoDetailSubject.send(crypto)
            }.store(in: &subscriptions)
    }
    
    func getSymbol() -> String {
        return "\(entity.symbol.uppercased())/USD"
    }
    
    private func parsePrice(price: Double) -> String {
        CKLogger.info("Price is :\(price)")
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
    
    var imageRepository: ImageRepositoryProtocol {
        return _imageRepository
    }
}
