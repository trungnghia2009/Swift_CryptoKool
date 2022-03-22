//
//  CryptoSearchVC.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import UIKit
import ReactiveSwift

final class CryptoSearchVC: UITableViewController {

    // MARK: - Properties
    private let viewModel: CryptoSearchVM
    private let searchController = UISearchController()
    private var debouncer: Debouncer!
    private var textFieldValue = "" {
        didSet {
            debouncer.call()
        }
    }
    
    // MARK: - Lifecycle
    init(viewModel: CryptoSearchVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debouncer = Debouncer(delay: 0.5) { [weak self] in
            self?.callSearchAPI()
        }
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
        viewModel.state.signal.observe { [weak self] _ in
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
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.searchTextField.returnKeyType = .done
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    private func setupTableView() {
        tableView.register(CryptoSearchCell.self, forCellReuseIdentifier: CryptoSearchCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func callSearchAPI() {
        CKLog.info(message: "Search value: \(textFieldValue)")
        viewModel.searchCrypto(searchKey: textFieldValue)
    }
}

// MARK: - UITableViewDataSource
extension CryptoSearchVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRowsInSection(section) == 0 {
            tableView.setEmptyMessage(message: viewModel.getState().rawValue, size: 20)
        } else {
            tableView.restore()
        }
        return viewModel.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoSearchCell.reuseIdentifier, for: indexPath) as? CryptoSearchCell
        else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        
        let cryptoSearchEntity = viewModel.cryptoAtIndex(indexPath.row)
        cell.viewModel = CryptoSearchCellVM(crypto: cryptoSearchEntity)
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
        
        let cryptoDetailEntity = selectedItem.mapToDetailEntity()
        let cryptoDetailVM = CryptoDetailVM(service: viewModel.getService(), entity: cryptoDetailEntity)
        controller.viewModel = cryptoDetailVM
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: UISearchControllerDelegate
extension CryptoSearchVC: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textFieldValue = searchText
    }
}

extension CryptoSearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        CKLog.info(message: "Tapped cancel...")
        navigationController?.popViewController(animated: true)
    }
}
