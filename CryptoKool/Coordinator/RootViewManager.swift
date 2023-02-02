//
//  PresenterManager.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import UIKit

final class RootViewManager {
    
    static let shared = RootViewManager()
    private let coordinator = MainCoordinator()
    
    private init() {}
    
    func show(view: RootView) {
        
        var vc: UIViewController & Coordinating
        
        switch view {
        case .cryptoListScreen:
            vc = CryptoListVC()
        case .firstScreen:
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            vc = FirstScreen()
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        
        coordinator.navigationController = navVC
        vc.coordinator = self.coordinator
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            window.rootViewController = navVC
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil)
        }
    }
}
