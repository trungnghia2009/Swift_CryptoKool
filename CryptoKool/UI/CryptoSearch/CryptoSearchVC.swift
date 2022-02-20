//
//  CryptoSearchVC.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class CryptoSearchVC: UITableViewController {

    // MARK: - Properties
    private let searchController = UISearchController()
    private let viewModel = CryptoSearchVM(service: CrytoService(coinGeckoService: CoinGeckoService()), state: .begin)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        configureSearchController()
        setupObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoSearchVC...")
    }
    
    // MARK: - Helpers
    private func setupObserver() {
        viewModel.searchList.signal.observe { [weak self] _ in
            CKLog.info(message: "Reload data...")
            self?.tableView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.setHidesBackButton(true, animated:true) // hide back button
    }
    
    private func configureSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.searchTextField.returnKeyType = .done
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        // Using debounce for sending key
        searchController.searchBar.searchTextField.reactive
            .controlEvents(.editingChanged)
            .debounce(0.5, on: QueueScheduler.main)
            .observeValues { [weak self] (textField) in
                if let text = textField.text, text.count > 0 {
                    self?.viewModel.searchMovies(searchKey: text)
                }
                
            }
    }
    
    private func setupTableView() {
        tableView.register(CryptoSearchCell.self, forCellReuseIdentifier: CryptoSearchCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Selectors
    
}

// MARK: - UITableViewDataSource
extension CryptoSearchVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRowsInSection(section) == 0 {
            tableView.setEmptyMessage(message: viewModel.setTextResult(), size: 20)
        } else {
            tableView.restore()
        }
        
        return viewModel.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoSearchCell.reuseIdentifier, for: indexPath) as? CryptoSearchCell else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        
        let cryptoSearchEntity = viewModel.cryptoAtIndex(indexPath.row)
        cell.viewModel = CryptoSearchCellVM(crpto: cryptoSearchEntity)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CryptoSearchVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.cryptoAtIndex(indexPath.row)
        CKLog.info(message: "Did tap item with id: \(selectedItem.id)")
        let storyboard = UIStoryboard(name: "CryptoDetailVC", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CryptoDetailVC") as? CryptoDetailVC else {
            return
        }
        controller.id = selectedItem.id
        controller.symbol = selectedItem.symbol
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension CryptoSearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchKey = searchController.searchBar.text else { return }
        if searchKey.count == 0 {
            viewModel.setState(state: .begin)
            viewModel.searchList.value.removeAll()
        }
    }
}

// MARK: UISearchControllerDelegate
extension CryptoSearchVC: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension CryptoSearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        CKLog.info(message: "Tapped cancel...")
        navigationController?.popViewController(animated: true)
    }
}
