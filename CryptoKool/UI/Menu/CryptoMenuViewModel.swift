//
//  MenuViewModel.swift
//  Menu_Expand_Collapse
//
//  Created by trungnghia on 07/12/2022.
//

import Foundation

class CryptoMenuViewModel {
    let sections: [CryptoMenuModel] = [
        CryptoMenuModel(title: .home, options: [.homeTop100, .homeSearch]),
        CryptoMenuModel(title: .favorite, options: []),
        CryptoMenuModel(title: .about, options: []),
        CryptoMenuModel(title: .report, options: []),
        CryptoMenuModel(title: .exit, options: [])
    ]
    
    func createMainMenuWithoutSubMenu(menu: String) -> CryptoMenuModel.MainMenuWithoutSubMenu? {
        CryptoMenuModel.MainMenuWithoutSubMenu(rawValue: menu)
    }
}
