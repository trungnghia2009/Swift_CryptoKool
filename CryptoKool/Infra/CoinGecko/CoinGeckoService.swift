//
//  CoinGeckoService.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

enum CoinGeckoServiceError: Error, CustomStringConvertible {
    case statusCodeError(code: Int)
    case apiError(reason: String)
    case urlInvalid
    
    var description: String {
        switch self {
        case .statusCodeError(code: let code):
            return "Request got error with status code: \(code)"
        case .apiError(reason: let reason):
            return reason
        case .urlInvalid:
            return "Invalid URL"
        }
    }
}

final class CoinGeckoService: CoinGeckoInterface {
    
    func fetchCryptoList(amount: Int) -> AnyPublisher<[CryptoEntity], Error> {
        
        guard let url = URL(string: QueryLink.shared.getCryptoList(amount: amount)) else {
            return Fail<[CryptoEntity], Error>(
                error: CoinGeckoServiceError.urlInvalid
            ).eraseToAnyPublisher()
        }
        CKLog.info("Request: \(url.absoluteURL)")
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { data, response -> [CryptoEntity] in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw CoinGeckoServiceError.statusCodeError(code: (response as? HTTPURLResponse)?.statusCode ?? 400)
                }
                
                CKLog.info("---Current thread: \(Thread.current)", shouldLogContext: false)
                
                var cryptoList = [CryptoEntity]()
                
                let result = try JSONDecoder().decode([CryptoResponse].self, from: data)
                result.forEach { crypto in
                    let cryptoEntity = CryptoEntity(id: crypto.id,
                                                    symbol: crypto.symbol,
                                                    name: crypto.name,
                                                    rank: crypto.rank,
                                                    imageURL: crypto.image,
                                                    currentPrice: crypto.currentPrice,
                                                    priceChangePercentage24h: crypto.priceChangePercentage24h)
                    cryptoList.append(cryptoEntity)
                }
                
                return cryptoList
            }
            .mapError { error in
                if let error = error as? CoinGeckoServiceError {
                    return error
                } else {
                    return CoinGeckoServiceError.apiError(reason: error.localizedDescription)
                }
            }.eraseToAnyPublisher()
    }
    
    func fetchCryptoDetail(id: String) -> AnyPublisher<CryptoDetailEntity, Error> {
        guard let url = URL(string: QueryLink.shared.getCryptoDetail(id: id)) else {
            return Fail<CryptoDetailEntity, Error>(
                error: CoinGeckoServiceError.urlInvalid
            ).eraseToAnyPublisher()
        }
        CKLog.info("Request: \(url.absoluteURL)")
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) -> CryptoDetailEntity in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw CoinGeckoServiceError.statusCodeError(code: (response as? HTTPURLResponse)?.statusCode ?? 400)
                }
                
                let result = try JSONDecoder().decode(CryptoDetailResponse.self, from: data)
                CKLog.info("Result is: \(result)")
                let cryptoDetailEntity = CryptoDetailEntity(id: result.id,
                                                            symbol: result.symbol,
                                                            name: result.name,
                                                            imageURL: result.imageURL.large,
                                                            homePage: result.links.homepage,
                                                            currentPrice: result.marketData.currentPrice?.usd,
                                                            priceChangePercentage24h: result.marketData.priceChangePercentage24h,
                                                            rank: result.marketData.rank,
                                                            high24h: result.marketData.high24h?.usd,
                                                            low24h: result.marketData.low24h?.usd,
                                                            marketCap: result.marketData.marketCap?.usd)
                return cryptoDetailEntity
            }
            .mapError { error in
                if let error = error as? CoinGeckoServiceError {
                    return error
                } else {
                    return CoinGeckoServiceError.apiError(reason: error.localizedDescription)
                }
            }.eraseToAnyPublisher()
    }
    
    func searchCrypto(keyword: String) -> AnyPublisher<[CryptoSearchEntity], Error> {

        guard let url = URL(string: QueryLink.shared.getSearch(keyword: keyword)) else {
            return Fail<[CryptoSearchEntity], Error>(
                error: CoinGeckoServiceError.urlInvalid
            ).eraseToAnyPublisher()
        }
        CKLog.info("Request: \(url.absoluteURL)")
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) -> [CryptoSearchEntity] in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw CoinGeckoServiceError.statusCodeError(code: (response as? HTTPURLResponse)?.statusCode ?? 400)
                }
                
                var searchList = [CryptoSearchEntity]()
                let result = try JSONDecoder().decode(CryptoSearchResponse.self, from: data)
                result.coins.forEach { crypto in
                    let cryptoSearchEntity = CryptoSearchEntity(id: crypto.id,
                                                                symbol: crypto.symbol,
                                                                name: crypto.name,
                                                                rank: crypto.rank,
                                                                imageURL: crypto.imageURL)
                    searchList.append(cryptoSearchEntity)
                }
                return searchList
            }
            .mapError { error in
                if let error = error as? CoinGeckoServiceError {
                    return error
                } else {
                    return CoinGeckoServiceError.apiError(reason: error.localizedDescription)
                }
            }.eraseToAnyPublisher()
    }
}
