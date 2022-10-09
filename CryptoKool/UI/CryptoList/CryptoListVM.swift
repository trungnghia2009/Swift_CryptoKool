//
//  CryptoListVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

final class CryptoListVM {
    
    @Injected var service: CryptoServiceInterface
    private var subscriptions = Set<AnyCancellable>()
    private let amount = 100
    
    private let cryptoListSubject = CurrentValueSubject<[CryptoEntity], Never>([])
    var updateObserver: AnyPublisher<Void, Never> {
        return cryptoListSubject
            .map { list -> Void in }
            .dropFirst(1) // drop [] value
            .eraseToAnyPublisher()
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
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        CKLog.info(message: "FetchCryptoListUseCase completed...")
                    case .failure(let error):
                        if let coinError = error as? CoinGeckoServiceError {
                            print("Error: \(coinError)")
                        }
                    }
                },
                receiveValue: { [weak self] crytoList in
                    self?.cryptoListSubject.send(crytoList)
                })
            .store(in: &subscriptions)
    }
}
