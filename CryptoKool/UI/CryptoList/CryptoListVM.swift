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
    private(set) var cryptoList = CurrentValueSubject<[CryptoEntity], Never>([])
    private var subscriptions = Set<AnyCancellable>()
    private let amount = 100
    
    init(service: CryptoServiceInterface = CryptoService(coinGeckoService: CoinGeckoService())) {
        self.service = service
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoListVM...")
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return cryptoList.value.count
    }
    
    func cryptoAtIndex(_ index: Int) -> CryptoEntity {
        return cryptoList.value[index]
    }
    
    func fetchCryptoList() {
        let useCase = FetchCryptoListUseCase(service: service)
        useCase.execute(param: amount)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        CKLog.error(message: "Retrieving data with error: \(error)")
                    }
                },
                receiveValue: { [weak self] crytoList in
                    self?.cryptoList.send(crytoList)
                })
            .store(in: &subscriptions)
    }
}
