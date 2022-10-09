//
//  Injections.swift
//  iosApp
//
//  Created by Quan on 01/08/2022.
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
        register { CryptoService(coinGeckoService: CoinGeckoService()) as CryptoServiceInterface }
    }
}
