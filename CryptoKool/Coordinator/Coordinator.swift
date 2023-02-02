//
//  Coordinator.swift
//  CryptoKool
//
//  Created by trungnghia on 28/01/2023.
//

import UIKit

enum Event {
    case searchScreen
    case informationScreen
    case menuScreen(delegate: CryptoMenuViewControllerDelegate)
    case detailScreen(viewModel: CryptoDetailVM)
}

enum RootView {
    case cryptoListScreen
    case firstScreen
}

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func eventOccurred(with type: Event)
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
