//
//  CryptoSearchVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import Combine

enum SearchState: String {
    case begin = "Please type your keyword."
    case loading = "Loading..."
    case done = ""
    case noResult = "There is no result."
}


final class CryptoSearchVM {
    
    private let service: CryptoServiceInterface
    private var searchList = [CryptoSearchEntity]()
    private var subscriptions = Set<AnyCancellable>()
    
    private let stateSubject = CurrentValueSubject<SearchState, Never>(.begin)
    var state: AnyPublisher<Void, Never> {
        return stateSubject
            .map { searchState -> Void in }
            .eraseToAnyPublisher()
    }
    
    init(service: CryptoServiceInterface) {
        self.service = service
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoSearchVM...")
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
                    CKLog.error(message: "Retrieving data with error: \(error)")
                }
            } receiveValue: { [weak self] crytoList in
                CKLog.info(message: "Got list success... : \(crytoList.count)")
                self?.searchList = crytoList
                if crytoList.count == 0 {
                    self?.stateSubject.send(.noResult)
                } else {
                    self?.stateSubject.send(.done)
                }
            }.store(in: &subscriptions)
    }
    
    func getService() -> CryptoServiceInterface {
        return service
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        let numberOfRows = searchList.count
        return numberOfRows
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
