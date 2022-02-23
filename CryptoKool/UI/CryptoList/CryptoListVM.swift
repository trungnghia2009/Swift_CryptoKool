//
//  CryptoListVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import ReactiveSwift

final class CryptoListVM {
    
    private let service: CryptoServiceInterface
    private(set) var cryptoList = MutableProperty<[CryptoEntity]>([])
    
    init(service: CryptoServiceInterface) {
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
        let useCase = FetchCryptoList(service: service)
        useCase.execute(param: 100)
            .observe(on: UIScheduler())
            .startWithResult({ [weak self] result in
                switch result {
                case .success(let list):
                    CKLog.info(message: "Got list success... : \(list.count)")
                    self?.cryptoList.value = list
                case .failure(let error):
                    CKLog.error(message: error.localizedDescription)
                }
            })
    }
}
