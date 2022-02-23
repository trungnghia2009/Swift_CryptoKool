//
//  CryptoSearchVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import ReactiveSwift

enum SearchState: String {
    case begin = "Please type your keyword."
    case loading = "Loading..."
    case done = ""
    case noResult = "There is no result."
}


final class CryptoSearchVM {
    
    private let service: CryptoServiceInterface
    private(set) var state = MutableProperty<SearchState>(.begin)
    private(set) var searchList = [CryptoSearchEntity]()
    
    init(service: CryptoServiceInterface) {
        self.service = service
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoSearchVM...")
    }
    
    func searchCrypto(searchKey: String) {
        if searchKey.isEmpty {
            searchList.removeAll()
            state.value = .begin
            return
        }
        state.value = .loading
        let useCase = SearchCryptoUseCase(service: service)
        useCase.execute(param: searchKey)
            .observe(on: UIScheduler())
            .startWithResult({ [weak self] result in
                switch result {
                case .success(let list):
                    CKLog.info(message: "Got list success... : \(list.count)")
                    self?.searchList = list
                    if list.count == 0 {
                        self?.state.value = .noResult
                    } else {
                        self?.state.value = .done
                    }
                case .failure(let error):
                    CKLog.error(message: error.localizedDescription)
                }
            })
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
    
    func getState() -> SearchState {
        return state.value
    }
}
