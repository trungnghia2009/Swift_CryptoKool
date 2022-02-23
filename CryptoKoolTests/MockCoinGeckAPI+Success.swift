//
//  MockCoinGeckAPI+Success.swift
//  CryptoKoolTests
//
//  Created by nghiaTran16 on 21/02/2022.
//

@testable import CryptoKool
import ReactiveSwift

class MockCongeckoAPI_Success1: CoinGeckoInterface {
    func fetchCryptoList(amount: Int) -> SignalProducer<[CryptoEntity], Error> {
        return SignalProducer { observer, _ in
            guard let data = Helpers.shared.getJsonData(name: "cryptoList") else {
                observer.send(value: [CryptoEntity]())
                observer.sendCompleted()
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
                observer.send(value: cryptoList)
                observer.sendCompleted()
            } catch {
                print("Nothing here")
            }
        }
    }
    
    func fetchCryptoDetail(id: String) -> SignalProducer<CryptoDetailEntity, Error> {
        return SignalProducer { observer, _ in
            guard let data = Helpers.shared.getJsonData(name: "cryptoDetail1") else {
                observer.sendCompleted()
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
                
                observer.send(value: cryptoDetailEntity)
                observer.sendCompleted()
            } catch {
                observer.send(error: CoinGeckoServiceError.decodingError)
                observer.sendCompleted()
            }
        }
    }
    
    func searchCrypto(keyword: String) -> SignalProducer<[CryptoSearchEntity], Error> {
        return SignalProducer { observer, _ in
            guard let data = Helpers.shared.getJsonData(name: "cryptoSearch") else {
                observer.sendCompleted()
                observer.send(value: [CryptoSearchEntity]())
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
                observer.send(value: searchList)
                observer.sendCompleted()
            } catch {
                observer.send(error: CoinGeckoServiceError.decodingError)
                observer.sendCompleted()
            }
        }
    }
}


class MockCongeckoAPI_Success2: CoinGeckoInterface {
    func fetchCryptoList(amount: Int) -> SignalProducer<[CryptoEntity], Error> {
        return SignalProducer { observer, _ in
            observer.send(error: CoinGeckoServiceError.decodingError)
            observer.sendCompleted()
        }
    }
    
    func fetchCryptoDetail(id: String) -> SignalProducer<CryptoDetailEntity, Error> {
        return SignalProducer { observer, _ in
            guard let data = Helpers.shared.getJsonData(name: "cryptoDetail2") else {
                observer.sendCompleted()
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
                
                observer.send(value: cryptoDetailEntity)
                observer.sendCompleted()
            } catch {
                observer.send(error: CoinGeckoServiceError.decodingError)
                observer.sendCompleted()
            }
        }
    }
    
    func searchCrypto(keyword: String) -> SignalProducer<[CryptoSearchEntity], Error> {
        return SignalProducer { observer, _ in
            observer.send(error: CoinGeckoServiceError.statusCodeError)
            observer.sendCompleted()
        }
    }
}

class MockCongeckoAPI_Success3: CoinGeckoInterface {
    func fetchCryptoList(amount: Int) -> SignalProducer<[CryptoEntity], Error> {
        return SignalProducer { observer, _ in
            observer.send(error: CoinGeckoServiceError.decodingError)
            observer.sendCompleted()
        }
    }
    
    func fetchCryptoDetail(id: String) -> SignalProducer<CryptoDetailEntity, Error> {
        return SignalProducer { observer, _ in
            guard let data = Helpers.shared.getJsonData(name: "cryptoDetail3") else {
                observer.sendCompleted()
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
                
                observer.send(value: cryptoDetailEntity)
                observer.sendCompleted()
            } catch {
                observer.send(error: CoinGeckoServiceError.decodingError)
                observer.sendCompleted()
            }
        }
    }
    
    func searchCrypto(keyword: String) -> SignalProducer<[CryptoSearchEntity], Error> {
        return SignalProducer { observer, _ in
            observer.send(error: CoinGeckoServiceError.statusCodeError)
            observer.sendCompleted()
        }
    }
}
