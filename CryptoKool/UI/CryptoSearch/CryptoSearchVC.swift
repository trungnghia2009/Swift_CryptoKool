//
//  CryptoSearchVC.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import UIKit
import Combine

final class CryptoSearchVC: UITableViewController {

    // MARK: - Properties
    private let viewModel = CryptoSearchVM()
    private var subscriptions = [AnyCancellable]()
    private let searchController = UISearchController()
    private var debouncer: Debouncer!
    private var textFieldValue = "" {
        didSet {
            debouncer.call()
        }
    }
    
    enum CryptoSearchVCSection {
        case main
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<CryptoSearchVCSection, CryptoSearchEntity> = {
        let dataSource = UITableViewDiffableDataSource<CryptoSearchVCSection, CryptoSearchEntity>(tableView: tableView)
        { [weak self] tableView, indexPath, cryptoEntity in
            
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: CryptoSearchCell.reuseIdentifier) as? CryptoSearchCell
            else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            
            let cryptoSearchEntity = self.viewModel.cryptoAtIndex(indexPath.row)
            cell.viewModel = CryptoSearchCellVM(crypto: cryptoSearchEntity)
            return cell
        }
        
        return dataSource
    }()
    
    // MARK: - Lifecycle
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
        viewModel.state
            .sink { [weak self] in
                guard let self = self else { return }
                CKLog.info(message: "Reload data...")
                self.configureSnapshot(for: self.viewModel.getCryptoList())
            }.store(in: &subscriptions)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.setHidesBackButton(true, animated: false) // hide back button
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
    
    private func configureSnapshot(for list: [CryptoSearchEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<CryptoSearchVCSection, CryptoSearchEntity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        if list.count == 0 {
            tableView.setEmptyMessage(message: viewModel.getState().rawValue, size: 20)
        } else {
            tableView.restore()
        }
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
        let cryptoDetailVM = CryptoDetailVM(entity: cryptoDetailEntity)
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
