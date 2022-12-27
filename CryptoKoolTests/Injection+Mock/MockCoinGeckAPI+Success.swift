//
//  MockCoinGeckAPI+Success.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

@testable import CryptoKool
import Foundation
import Combine

class MockCongeckoAPI_Success1: CoinGeckoInterface {
    func fetchCryptoList(amount: Int) -> AnyPublisher<[CryptoEntity], Error> {
        return Future<[CryptoEntity], Error> { promise in
            guard let data = Helpers.shared.getJsonData(name: "cryptoList") else {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot find data")))
                return
            }
            
            var cryptoList = [CryptoEntity]()
            do {
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
                promise(.success(cryptoList))
            } catch {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot decode")))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchCryptoDetail(id: String) -> AnyPublisher<CryptoDetailEntity, Error> {
        return Future<CryptoDetailEntity, Error> { promise in
            guard let data = Helpers.shared.getJsonData(name: "cryptoDetail1") else {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot find data")))
                return
            }
            
            do {
                let cryptoDetail = try JSONDecoder().decode(CryptoDetailResponse.self, from: data)
                let cryptoDetailEntity = CryptoDetailEntity(id: cryptoDetail.id,
                                                            symbol: cryptoDetail.symbol,
                                                            name: cryptoDetail.name,
                                                            imageURL: cryptoDetail.imageURL.large,
                                                            homePage: cryptoDetail.links.homepage,
                                                            currentPrice: cryptoDetail.marketData.currentPrice?.usd,
                                                            priceChangePercentage24h: cryptoDetail.marketData.priceChangePercentage24h,
                                                            rank: cryptoDetail.marketData.rank,
                                                            high24h: cryptoDetail.marketData.high24h?.usd,
                                                            low24h: cryptoDetail.marketData.low24h?.usd,
                                                            marketCap: cryptoDetail.marketData.marketCap?.usd)
                
                promise(.success(cryptoDetailEntity))
            } catch {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot decode")))
            }
        }.eraseToAnyPublisher()
    }
    
    func searchCrypto(keyword: String) -> AnyPublisher<[CryptoSearchEntity], Error> {
        return Future<[CryptoSearchEntity], Error> { promise in
            guard let data = Helpers.shared.getJsonData(name: "cryptoSearch") else {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot find data")))
                return
            }
            
            var searchList = [CryptoSearchEntity]()
            do {
                let result = try JSONDecoder().decode(CryptoSearchResponse.self, from: data)
                result.coins.forEach { crypto in
                    let cryptoSearchEntity = CryptoSearchEntity(id: crypto.id,
                                                                symbol: crypto.symbol,
                                                                name: crypto.name,
                                                                rank: crypto.rank,
                                                                imageURL: crypto.imageURL)
                    
                    searchList.append(cryptoSearchEntity)
                }
                promise(.success(searchList))
            } catch {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot decode")))
            }
        }.eraseToAnyPublisher()
    }
}


class MockCongeckoAPI_Success2: CoinGeckoInterface {
    func fetchCryptoList(amount: Int) -> AnyPublisher<[CryptoEntity], Error> {
        return Future<[CryptoEntity], Error> { promise in
            promise(.failure(CoinGeckoServiceError.apiError(reason: "Not use this function")))
        }.eraseToAnyPublisher()
    }
    
    func fetchCryptoDetail(id: String) -> AnyPublisher<CryptoDetailEntity, Error> {
        return Future<CryptoDetailEntity, Error> { promise in
            guard let data = Helpers.shared.getJsonData(name: "cryptoDetail2") else {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot find data")))
                return
            }
            
            do {
                let cryptoDetail = try JSONDecoder().decode(CryptoDetailResponse.self, from: data)
                let cryptoDetailEntity = CryptoDetailEntity(id: cryptoDetail.id,
                                                            symbol: cryptoDetail.symbol,
                                                            name: cryptoDetail.name,
                                                            imageURL: cryptoDetail.imageURL.large,
                                                            homePage: cryptoDetail.links.homepage,
                                                            currentPrice: cryptoDetail.marketData.currentPrice?.usd,
                                                            priceChangePercentage24h: cryptoDetail.marketData.priceChangePercentage24h,
                                                            rank: cryptoDetail.marketData.rank,
                                                            high24h: cryptoDetail.marketData.high24h?.usd,
                                                            low24h: cryptoDetail.marketData.low24h?.usd,
                                                            marketCap: cryptoDetail.marketData.marketCap?.usd)
                
                promise(.success(cryptoDetailEntity))
            } catch {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot decode")))
            }
        }.eraseToAnyPublisher()
    }
    
    func searchCrypto(keyword: String) -> AnyPublisher<[CryptoSearchEntity], Error> {
        return Future<[CryptoSearchEntity], Error> { promise in
            promise(.failure(CoinGeckoServiceError.apiError(reason: "Not use this function")))
        }.eraseToAnyPublisher()
    }
}

class MockCongeckoAPI_Success3: CoinGeckoInterface {
    func fetchCryptoList(amount: Int) -> AnyPublisher<[CryptoEntity], Error> {
        return Future<[CryptoEntity], Error> { promise in
            promise(.failure(CoinGeckoServiceError.apiError(reason: "Not use this function")))
        }.eraseToAnyPublisher()
    }
    
    func fetchCryptoDetail(id: String) -> AnyPublisher<CryptoDetailEntity, Error> {
        return Future<CryptoDetailEntity, Error> { promise in
            guard let data = Helpers.shared.getJsonData(name: "cryptoDetail3") else {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot find data")))
                return
            }
            
            do {
                let cryptoDetail = try JSONDecoder().decode(CryptoDetailResponse.self, from: data)
                let cryptoDetailEntity = CryptoDetailEntity(id: cryptoDetail.id,
                                                            symbol: cryptoDetail.symbol,
                                                            name: cryptoDetail.name,
                                                            imageURL: cryptoDetail.imageURL.large,
                                                            homePage: cryptoDetail.links.homepage,
                                                            currentPrice: cryptoDetail.marketData.currentPrice?.usd,
                                                            priceChangePercentage24h: cryptoDetail.marketData.priceChangePercentage24h,
                                                            rank: cryptoDetail.marketData.rank,
                                                            high24h: cryptoDetail.marketData.high24h?.usd,
                                                            low24h: cryptoDetail.marketData.low24h?.usd,
                                                            marketCap: cryptoDetail.marketData.marketCap?.usd)
                
                promise(.success(cryptoDetailEntity))
            } catch {
                promise(.failure(CoinGeckoServiceError.apiError(reason: "Cannot decode")))
            }
        }.eraseToAnyPublisher()
    }
    
    func searchCrypto(keyword: String) -> AnyPublisher<[CryptoSearchEntity], Error> {
        return Future<[CryptoSearchEntity], Error> { promise in
            promise(.failure(CoinGeckoServiceError.apiError(reason: "Not use this function")))
        }.eraseToAnyPublisher()
    }
}
