//
//  CryptoSearchVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

enum SearchState {
    case begin
    case loading
    case done
    case noResult
    
    var text: String {
        switch self {
        case .begin:
            return CKLanguage.text("search_emtpy", comment: "Please type your keyword.")
        case .loading:
            return CKLanguage.text("search_loading", comment: "Loading...")
        case .done:
            return ""
        case .noResult:
            return CKLanguage.text("search_no_result", comment: "There is no result.")
        }
    }
}


final class CryptoSearchVM {
    
    @Injected private var service: CryptoServiceInterface
    
    private var searchList = [CryptoSearchEntity]()
    private var subscriptions = Set<AnyCancellable>()
    
    private let stateSubject = CurrentValueSubject<SearchState, Never>(.begin)
    var state: AnyPublisher<Void, Never> {
        return stateSubject
            .map { searchState -> Void in }
            .eraseToAnyPublisher()
    }
    
    deinit {
        CKLogger.info("Deinit CryptoSearchVM...")
    }
    
    func searchCrypto(searchKey: String) {
        if searchKey.isEmpty {
            searchList.removeAll()
            stateSubject.send(.begin)
            return
        }
        
        stateSubject.send(.loading)
        let useCase = SearchCryptoUseCase(service: service)
        useCase.execute(param: searchKey)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    CKLogger.error("Retrieving data with error: \(error)")
                }
            } receiveValue: { [weak self] crytoList in
                CKLogger.info("Got list success... : \(crytoList.count)")
                self?.searchList = crytoList
                if crytoList.count == 0 {
                    self?.stateSubject.send(.noResult)
                } else {
                    self?.stateSubject.send(.done)
                }
            }.store(in: &subscriptions)
    }
    
    func cryptoAtIndex(_ index: Int) -> CryptoSearchEntity {
        return searchList[index]
    }
    
    func getCryptoList() -> [CryptoSearchEntity] {
        return searchList
    }
    
    func getState() -> SearchState {
        return stateSubject.value
    }
}
