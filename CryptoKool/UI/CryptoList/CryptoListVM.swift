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
        CKLog.info(message: "Deinit CryptoListVM...")
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
                        CKLog.info(message: "FetchCryptoListUseCase completed...")
                    case .failure(let error):
                        if let coinError = error as? CoinGeckoServiceError {
                            CKLog.error(message: "Error: \(coinError)")
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
                CKLog.info(message: "Completed with: \(completion)")
            } receiveValue: { [weak self] cryptoDBList in
                let cryptoCount = cryptoDBList.count
                CKLog.info(message: "crptoDBList count: \(cryptoDBList.count)")
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
