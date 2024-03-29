//
//  CryptoUseCases.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

protocol CryptoUseCaseWithResult: AnyObject {
    associatedtype ReturnValue
    func execute() -> AnyPublisher<ReturnValue, Error>
}

protocol CryptoUseCaseWithParam: AnyObject {
    associatedtype Param
    associatedtype ReturnValue

    func execute(param: Param) -> AnyPublisher<ReturnValue, Error>
}

protocol CryptoUseCaseWithoutResult {
    associatedtype Param

    func execute(param: Param)
}

protocol CryptoUseCaseWithoutParamAndResult: AnyObject {
    func execute()
}
