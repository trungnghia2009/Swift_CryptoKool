//
//  MenuModel.swift
//  Menu_Expand_Collapse
//
//  Created by trungnghia on 07/12/2022.
//

import Foundation

protocol MenuNameWithSubMenu {
    static var home: Self { get }
}

protocol MenuNameWithOutSubMenu {
    static var favorite: Self { get }
    static var about: Self { get }
}

class MenuModel {
    let title: MainMenu
    let options: [SubMenu]
    var isOpened = false
    
    init(title: MainMenu, options: [SubMenu], isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
    
    enum MainMenu: String, MenuNameWithSubMenu, MenuNameWithOutSubMenu {
        case home
        case favorite
        case about
        
        var menuImage: String {
            switch self {
            case .home: return "house"
            case .favorite: return "star"
            case .about: return "info.circle"
            }
        }
    }
    
    enum MainMenuWithoutSubMenu: String, MenuNameWithOutSubMenu {
        case favorite
        case about
    }
    
    enum SubMenu: String {
        case homeFeature1 = "Top 100"
        case homeFeature2 = "Search"
    }
}
