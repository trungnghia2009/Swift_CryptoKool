//
//  MenuViewModel.swift
//  Menu_Expand_Collapse
//
//  Created by trungnghia on 07/12/2022.
//

import Foundation

class MenuViewModel {
    let sections: [MenuModel] = [
        MenuModel(title: .home, options: [.homeFeature1, .homeFeature2]),
        MenuModel(title: .favorite, options: [])
    ]
    
    func createMainMenuWithoutSubMenu(menu: String) -> MenuModel.MainMenuWithoutSubMenu? {
        MenuModel.MainMenuWithoutSubMenu(rawValue: menu)
    }
}
