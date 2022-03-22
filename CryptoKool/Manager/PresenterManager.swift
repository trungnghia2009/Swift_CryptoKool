//
//  PresenterManager.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import UIKit

final class PresenterManager {
    
    static let shared = PresenterManager()
    
    private init() {}
    
    enum VC {
        case firstScreen
        case cryptoListScreen
        case informationScreen
    }
    
    func show(vc: VC) {
        var viewController: UIViewController
        
        switch vc {
        case .firstScreen:
            viewController = FirstScreen()
        case .cryptoListScreen:
            viewController = UINavigationController(rootViewController: CryptoListVC())
        case .informationScreen:
            viewController = UINavigationController(rootViewController: InformationScreen())
        }
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil)
        }
    }
}
