//
//  CryptoFavoriteVC.swift
//  CryptoKool
//
//  Created by trungnghia on 09/02/2023.
//

import UIKit

class CryptoFavoriteVC: UIViewController, Coordinating {

    // MARK: Properties
    var coordinator: Coordinator?
    private var viewModel = CryptoFavoriteVM()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Helpers
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = CKLanguage.text("favorite_title", comment: "Favorite List")
    }
    
    // MARK: Selectors

}
