//
//  CryptoEntity+CoreDataClass.swift
//  
//
//  Created by trungnghia on 09/10/2022.
//
//

import Foundation
import CoreData

@objc(CryptoDB)
public class CryptoDB: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CryptoDB> {
        return NSFetchRequest<CryptoDB>(entityName: "CryptoDB")
    }
    
    @nonobjc public class func deleteRequest() -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CryptoDB")
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }

    @NSManaged public var id: String?
    @NSManaged public var symbol: String?
    @NSManaged public var name: String?
    @NSManaged public var rank: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var currentPrice: Double
    @NSManaged public var priceChangePercentage24h: Double
    
    func mapToCryptoEntity() -> CryptoEntity {
        let cryptoEntity = CryptoEntity(id: self.id ?? "",
                                        symbol: self.symbol ?? "",
                                        name: self.name ?? "",
                                        rank: Int(self.rank),
                                        imageURL: self.imageURL,
                                        currentPrice: self.currentPrice,
                                        priceChangePercentage24h: self.priceChangePercentage24h)
        
        
        return cryptoEntity
    }
}
