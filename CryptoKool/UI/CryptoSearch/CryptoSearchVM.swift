//
//  CryptoSearchVM.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import Foundation
import ReactiveSwift

enum SearchState {
    case begin
    case noResult
}

final class CryptoSearchVM {
    
    private let service: CryptoServiceInterface
    private var state: SearchState
    private(set) var searchList = MutableProperty<[CryptoSearchEntity]>([])
    
    init(service: CryptoServiceInterface, state: SearchState) {
        self.service = service
        self.state = state
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoSearchVM...")
    }
    
    func searchMovies(searchKey: String) {
        let useCase = SearchCryptoUseCase(service: service)
        useCase.execute(param: searchKey)
            .observe(on: UIScheduler())
            .startWithResult({ [weak self] result in
                switch result {
                case .success(let list):
                    CKLog.info(message: "Got list success... : \(list.count)")
                    let cryptoCount = self?.searchList.value.count
                    if cryptoCount == 0 { self?.state = .noResult }
                    self?.searchList.value = list
                case .failure(let error):
                    CKLog.error(message: error.localizedDescription)
                }
            })
        
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        let numberOfRows = searchList.value.count
        return numberOfRows
    }
    
    func cryptoAtIndex(_ index: Int) -> CryptoSearchEntity {
        return searchList.value[index]
    }
    
    func setTextResult() -> String {
        switch state {
        case .begin:
            return "Please type your keyword."
        case .noResult:
            return "There is no result."
        }
    }
    
    func setState(state: SearchState) {
        self.state = state
    }
    
    
}
