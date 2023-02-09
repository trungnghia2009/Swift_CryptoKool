//
//  Coordinator.swift
//  CryptoKool
//
//  Created by trungnghia on 28/01/2023.
//

import UIKit
import MessageUI

enum Event {
    case searchScreen
    case informationScreen
    case menuScreen(delegate: CryptoMenuViewControllerDelegate)
    case detailScreen(viewModel: CryptoDetailVM)
    case favoriteScreen
    case emailScreen(controller: UIViewController, delegate: MFMailComposeViewControllerDelegate)
    case alertSimpleScreen(info: AlertInfo)
    case alertOptionsScreen(info: AlertInfo, action: () -> Void)
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
