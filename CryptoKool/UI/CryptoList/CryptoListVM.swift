//
//  CryptoListVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

final class CryptoListVM {
    
    @Injected private var service: CryptoServiceInterface
    @Injected private var coreDataService: CoreDataInterface
    
    private var subscriptions = Set<AnyCancellable>()
    private let amount = 100
    
    private let cryptoListSubject = CurrentValueSubject<[CryptoEntity], Never>([])
    private let errorSubject = PassthroughSubject<CoinGeckoServiceError, Never>()
    
    var onCryptoListChange: AnyPublisher<Void, Never> {
        return cryptoListSubject
            .map { list -> Void in }
            .dropFirst(1) // drop [] value
            .eraseToAnyPublisher()
    }
    var onError: AnyPublisher<CoinGeckoServiceError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    deinit {
        CKLogger.info("Deinit CryptoListVM...")
    }
    
    func cryptoAtIndex(_ index: Int) -> CryptoEntity {
        return cryptoListSubject.value[index]
    }
    
    func getCryptoList() -> [CryptoEntity] {
        return cryptoListSubject.value
    }
    
    func fetchCryptoList() {
        let useCase = FetchCryptoListUseCase(service: service)
        useCase.execute(param: amount)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        CKLogger.info("FetchCryptoListUseCase completed...")
                    case .failure(let error):
                        if let coinError = error as? CoinGeckoServiceError {
                            CKLogger.error("Error: \(coinError)")
                            self?.errorSubject.send(coinError)
                        }
                    }
                },
                receiveValue: { [weak self] crytoList in
                    self?.saveData(list: crytoList)
                    self?.cryptoListSubject.send(crytoList)
                })
            .store(in: &subscriptions)
    }
    
    func saveData(list: [CryptoEntity]) {
        coreDataService.saveData(entity: list)
    }
    
    func firstFetchFromDataBase() {
        coreDataService.fetchData()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                CKLogger.info("Completed with: \(completion)")
            } receiveValue: { [weak self] cryptoDBList in
                let cryptoCount = cryptoDBList.count
                CKLogger.info("crptoDBList count: \(cryptoDBList.count)")
                if cryptoCount == 0 { return }
                
                var entityList = [CryptoEntity]()
                cryptoDBList.forEach { cryptoDB in
                    entityList.append(cryptoDB.mapToCryptoEntity())
                }
                self?.cryptoListSubject.send(entityList)
            }
            .store(in: &subscriptions)

    }
}
