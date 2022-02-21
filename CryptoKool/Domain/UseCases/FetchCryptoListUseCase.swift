//
//  GetCryptoListUseCase.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import ReactiveSwift

final class FetchCryptoList: CryptoUseCaseWithParam {
    typealias Param = Int
    typealias ReturnValue = [CryptoEntity]
    private let service: CryptoServiceInterface
    
    init(service: CryptoServiceInterface) {
        self.service = service
    }
    
    func execute(param: Param) -> SignalProducer<ReturnValue, Error> {
        service.fetchCryptoList(amount: param)
    }
}
