//
//  TestCoreDataStack.swift
//  CryptoKoolTests
//
//  Created by trungnghia on 27/12/2022.
//

@testable import CryptoKool
import Foundation
import CoreData

class TestCoreDataStack: CoreDataStack {
    override init() {
        super.init()
        
        let container = NSPersistentContainer(name: CoreDataStack.modelName,
                                              managedObjectModel: CoreDataStack.model)
        
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        
        self.storeContainer = container
    }
}
