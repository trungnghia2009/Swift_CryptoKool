//
//  MainCoordinator.swift
//  CryptoKool
//
//  Created by trungnghia on 28/01/2023.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?
    private let alertController = CryptoAlert()
    
    func eventOccurred(with type: Event) {
        switch type {
        case .searchScreen:
            let vc = CryptoSearchVC()
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        case .informationScreen:
            let vc = InformationScreen()
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        case .menuScreen(let delegate):
            let vc = CryptoMenuViewController()
            vc.coordinator = self
            vc.delegate = delegate
            navigationController?.pushViewController(vc, animated: true)
        case .detailScreen(let viewModel):
            let storyboard = UIStoryboard(name: "CryptoDetailVC", bundle: Bundle.main)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "CryptoDetailVC") as? CryptoDetailVC else {
                return
            }
            vc.coordinator = self
            vc.viewModel =  viewModel
            navigationController?.pushViewController(vc, animated: true)
        case .favoriteScreen:
            let vc = CryptoFavoriteVC()
            navigationController?.pushViewController(vc, animated: true)
        case .emailScreen(let vc, let delegate):
            let mailManager = MailManager()
            mailManager.sendEmailWithLogAttachment(controller: vc, delegate: delegate)
        
        // Handle Alert
        case .alertSimpleScreen(let info):
            alertController.showSimple(alertInfo: info)
        case .alertOptionsScreen(let info, let action):
            alertController.showOptions(alertInfo: info, okButton: action)
        }
    }
    
}
