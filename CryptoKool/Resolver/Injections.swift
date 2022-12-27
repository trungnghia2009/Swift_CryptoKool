//
//  CryptoKool.swift
//  iosApp
//
//  Created by trungnghia on 01/08/2022.
//  Copyright © 2022 Tap Mobile. All rights reserved.
//

import Foundation

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerAppServices()
    }
}

extension Resolver {
    public static func registerAppServices() {
        defaultScope = .graph
        register { CryptoService(coinGeckoService: CoinGeckoService()) as CryptoServiceInterface }
        register { CoreDataService(coreDataStack: CoreDataStack()) as CoreDataInterface }
    }
}
