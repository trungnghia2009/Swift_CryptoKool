//
//  FetchCryptoDetailUseCase.swift
//  CryptoKool
//
//  Created by trungnghia on 20/02/2022.
//

import Foundation
import Combine

final class FetchCryptoDetailUseCase: CryptoUseCaseWithParam {
    typealias Param = String
    typealias ReturnValue = CryptoDetailEntity
    private let service: CryptoServiceInterface
    
    init(service: CryptoServiceInterface) {
        self.service = service
    }
    
    func execute(param: Param) -> AnyPublisher<CryptoDetailEntity, Error> {
        service.fetchCryptoDetail(id: param)
    }
}
