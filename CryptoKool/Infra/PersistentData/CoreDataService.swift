//
//  CoreDataService.swift
//  CryptoKool
//
//  Created by trungnghia on 09/10/2022.
//

import Foundation
import Combine
import CoreData

enum CoreDataError: Error {
    case couldNotFetch
}

protocol CoreDataInterface: AnyObject {
    func fetchData() -> AnyPublisher<[CryptoDB], Error>
    func saveData(entity: [CryptoEntity])
    func saveData()
}

final class CoreDataService: CoreDataInterface {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func fetchData() -> AnyPublisher<[CryptoDB], Error> {
        return Future<[CryptoDB], Error> { [weak self] promise in
            
            let cryptoFetchRequest = CryptoDB.fetchRequest()
            let asyncFetchRequest = NSAsynchronousFetchRequest<CryptoDB>(fetchRequest: cryptoFetchRequest) { result in
                if let result = result.finalResult {
                    promise(.success(result))
                } else {
                    // To be implemented
                }
            }
            
            let sort = NSSortDescriptor(key: #keyPath(CryptoDB.rank), ascending: true)
            asyncFetchRequest.fetchRequest.sortDescriptors = [sort]
            
            do {
                try self?.coreDataStack.backgroundContext.execute(asyncFetchRequest)
            } catch let error as NSError {
                CKLog.info(message: "Could not fetch \(error), \(error.userInfo)")
                promise(.failure(CoreDataError.couldNotFetch))
            }
            
        }.eraseToAnyPublisher()
        
        
    }
    
    func saveData() {
        coreDataStack.saveContext()
    }
    
    func saveData(entity: [CryptoEntity]) {
        CKLog.info(message: "SaveData to database")
        
        // Delete CryptoDB before saving
        do {
            try coreDataStack.managedContext.execute(CryptoDB.deleteRequest())
        } catch let error as NSError {
            CKLog.info(message: "Cannot delete CryptoDB: \(error)")
        }
        
        entity.forEach { crypto in
            let cryptoDB = CryptoDB(context: coreDataStack.managedContext)
            cryptoDB.id = crypto.id
            cryptoDB.symbol = crypto.symbol
            cryptoDB.name = crypto.name
            cryptoDB.imageURL = crypto.imageURL
            if let rank = crypto.rank {
                cryptoDB.rank = Int32(rank)
            }
            if let currentPrice = crypto.currentPrice {
                cryptoDB.currentPrice = currentPrice
            }
            if let priceChangePercentage24h = crypto.priceChangePercentage24h {
                cryptoDB.priceChangePercentage24h = priceChangePercentage24h
            }
        }
        coreDataStack.saveContext()
    }
    
}
