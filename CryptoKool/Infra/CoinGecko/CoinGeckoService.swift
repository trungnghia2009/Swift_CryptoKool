//
//  CoinGeckoService.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import ReactiveSwift

enum CoinGeckoServiceError: Error {
    case unvalidURL
    case statusCodeError
    case dataError
    case decodingError
}

final class CoinGeckoService: CoinGeckoInterface {
    
    func fetchCryptoList(amount: Int) -> SignalProducer<[CryptoEntity], Error> {
        let query = QueryLink.shared.getCryptoList(amount: amount)
        CKLog.info(message: "Request: \(query)")
        return SignalProducer { observer, _ in
            guard let resourceURL = URL(string: query) else {
                observer.send(error: CoinGeckoServiceError.unvalidURL)
                observer.sendCompleted()
                return
            }
            
            URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
                if let error = error {
                    observer.send(error: error)
                    observer.sendCompleted()
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    observer.send(error: CoinGeckoServiceError.statusCodeError)
                    observer.sendCompleted()
                    return
                }
                
                if let data = data {
                    var cryptoList = [CryptoEntity]()
                    let decoder = JSONDecoder()
                    
                    do {
                        let result = try decoder.decode([CryptoResponse].self, from: data)
                        CKLog.info(message: "\(result.count)")
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
                        observer.send(error: CoinGeckoServiceError.decodingError)
                        observer.sendCompleted()
                    }
                    
                } else {
                    observer.send(error: CoinGeckoServiceError.dataError)
                    observer.sendCompleted()
                }
                
            }.resume()
        }
    }
    
    func fetchCryptoDetail(id: String) -> SignalProducer<CryptoDetailEntity, Error> {
        let query = QueryLink.shared.getCryptoDetail(id: id)
        CKLog.info(message: "Request: \(query)")
        return SignalProducer { observer, _ in
            guard let resourceURL = URL(string: query) else {
                observer.send(error: CoinGeckoServiceError.unvalidURL)
                observer.sendCompleted()
                return
            }
            
            URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
                if let error = error {
                    observer.send(error: error)
                    observer.sendCompleted()
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    observer.send(error: CoinGeckoServiceError.statusCodeError)
                    observer.sendCompleted()
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let cryptoDetail = try decoder.decode(CryptoDetailResponse.self, from: data)
                        CKLog.info(message: "Result is: \(cryptoDetail)")
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
                        CKLog.info(message: "Decode error: \(error)")
                        observer.send(error: CoinGeckoServiceError.decodingError)
                        observer.sendCompleted()
                    }
                    
                } else {
                    observer.send(error: CoinGeckoServiceError.dataError)
                    observer.sendCompleted()
                }
                
            }.resume()
        }
    }
    
    func searchCrypto(keyword: String) -> SignalProducer<[CryptoSearchEntity], Error> {
        let query = QueryLink.shared.getSearch(keyword: keyword)
        let transformSearchKey = query.replacingOccurrences(of: " ", with: "%20")
        CKLog.info(message: "Request: \(transformSearchKey)")
        
        return SignalProducer { observer, _ in
            guard let resourceURL = URL(string: transformSearchKey) else {
                observer.send(error: CoinGeckoServiceError.unvalidURL)
                observer.sendCompleted()
                return
            }
            
            URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
                if let error = error {
                    observer.send(error: error)
                    observer.sendCompleted()
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    observer.send(error: CoinGeckoServiceError.statusCodeError)
                    observer.sendCompleted()
                    return
                }
                
                if let data = data {
                    var searchList = [CryptoSearchEntity]()
                    let decoder = JSONDecoder()
                    
                    do {
                        let result = try decoder.decode(CryptoSearchResponse.self, from: data)
                        CKLog.info(message: "Result is: \(result.coins)")
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
                    
                } else {
                    observer.send(error: CoinGeckoServiceError.dataError)
                    observer.sendCompleted()
                }
                
            }.resume()
        }
    }
}
