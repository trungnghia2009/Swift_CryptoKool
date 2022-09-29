//
//  CryptoListVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

final class CryptoListVM {
    
    private(set) var service: CryptoServiceInterface
    private var subscriptions = Set<AnyCancellable>()
    private let amount = 100
    
    private let cryptpListSubject = CurrentValueSubject<[CryptoEntity], Never>([])
    var cryptoList: AnyPublisher<[CryptoEntity], Never> {
        return cryptpListSubject.eraseToAnyPublisher()
    }
    
    init(service: CryptoServiceInterface = CryptoService(coinGeckoService: CoinGeckoService())) {
        self.service = service
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoListVM...")
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return cryptpListSubject.value.count
    }
    
    func cryptoAtIndex(_ index: Int) -> CryptoEntity {
        return cryptpListSubject.value[index]
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
                    self?.cryptpListSubject.send(crytoList)
                })
            .store(in: &subscriptions)
    }
}
