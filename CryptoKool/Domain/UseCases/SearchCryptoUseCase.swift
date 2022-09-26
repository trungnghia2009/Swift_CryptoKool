//
//  SearchCryptoUseCase.swift
//  CryptoKool
//
//  Created by trungnghia on 20/02/2022.
//

import Foundation
import Combine

final class SearchCryptoUseCase: CryptoUseCaseWithParam {
    typealias Param = String
    typealias ReturnValue = [CryptoSearchEntity]
    private let service: CryptoServiceInterface
    
    init(service: CryptoServiceInterface) {
        self.service = service
    }
    
    func execute(param: Param) -> AnyPublisher<ReturnValue, Error> {
        service.searchCrypto(keyword: param)
    }
}
