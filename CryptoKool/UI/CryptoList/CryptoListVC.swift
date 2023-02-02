//
//  CryptoListVCTableViewController.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import UIKit
import Combine

final class CryptoListVC: UITableViewController, Coordinating {
    
    // MARK: Properties
    var coordinator: Coordinator?
    private var subscriptions = [AnyCancellable]()
    private let viewModel = CryptoListVM()
    private var timer: Timer?
    private let fetchCycle: Double = 30
    
    enum CryptoListVCSection {
        case main
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<CryptoListVCSection, CryptoEntity> = {
        let dataSource = UITableViewDiffableDataSource<CryptoListVCSection, CryptoEntity>(tableView: tableView)
        { [weak self] tableView, indexPath, cryptoEntity in
            
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: CryptoListCell.reuseIdentifier) as? CryptoListCell
            else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            cell.viewModel = CryptoListCellVM(crypto: cryptoEntity)
            
            return cell
        }
        return dataSource
    }()
    
    private let searchButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .systemOrange
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.layer.cornerRadius = 25
        button.addShadow()
        button.addTarget(nil, action: #selector(didTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loadingIndicatorView, loadingLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        return stack
    }()
    
    private let loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .systemGray2
        label.text = "Loading..."
        return label
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.firstFetchFromDataBase()
        viewModel.fetchCryptoList()
        setupNavigationBar()
        setTableView()
        setupPullToRefresh()
        setupObserver()
        timer = Timer.scheduledTimer(timeInterval: fetchCycle, target: self, selector: #selector(callFetchData), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(searchButton)
        searchButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor,
                            paddingBottom: 30,
                            paddingRight: 20)
        
        view.addSubview(stackView)
        stackView.centerX(inView: view)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 200)
        
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoListVC...")
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: Helpers
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Top 100"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didInfoButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapMenuButton))
    }
    
    private func setTableView() {
        tableView.register(CryptoListCell.self, forCellReuseIdentifier: CryptoListCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupObserver() {
        viewModel.onCryptoListChange
            .sink { [weak self] in
                guard let self = self else { return }
                CKLog.info(message: "Reload tableview...")
                self.hideLoadingIndicatorView()
                self.configureSnapshot(for: self.viewModel.getCryptoList())
            }.store(in: &subscriptions)
        
        viewModel.onError
            .sink { [weak self] error in
                guard let self = self else { return }
                self.hideLoadingIndicatorView()
                let alert = CryptoAlert(controller: self)
                alert.showSimple(title: "Error", content: error.description)
            }.store(in: &subscriptions)
    }
    
    private func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(callFetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func hideLoadingIndicatorView() {
        self.tableView.refreshControl?.endRefreshing()
        self.loadingIndicatorView.stopAnimating()
        self.stackView.isHidden = true
    }
    
    private func reset() {
        timer?.invalidate()
        timer = nil
    }
    
    private func configureSnapshot(for list: [CryptoEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<CryptoListVCSection, CryptoEntity>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    // MARK: Selectors
    @objc private func didInfoButton() {
        CKLog.info(message: "Did tap Info button")
        coordinator?.eventOccurred(with: .informationScreen)
    }
    
    @objc private func didTapMenuButton() {
        CKLog.info(message: "Did tap Menu button")
        coordinator?.eventOccurred(with: .menuScreen(delegate: self))
    }
    
    @objc private func didTapSearchButton() {
        CKLog.info(message: "Did tap search button")
        coordinator?.eventOccurred(with: .searchScreen)
        
    }
    
    @objc private func callFetchData() {
        CKLog.info(message: "Fetching crpto list again...")
        viewModel.fetchCryptoList()
    }
}

// MARK: UITableViewDelegate
extension CryptoListVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.cryptoAtIndex(indexPath.row)
        
        let cryptoDetailEntity = selectedItem.mapToDetailEntity()
        let cryptoDetailVM = CryptoDetailVM(entity: cryptoDetailEntity)
        coordinator?.eventOccurred(with: .detailScreen(viewModel: cryptoDetailVM))
    }
}

// MARK: MenuViewControllerDelegate
extension CryptoListVC: CryptoMenuViewControllerDelegate {
    func didTapSearchMenu() {
        coordinator?.eventOccurred(with: .searchScreen)
    }
    
    func didTapInfomationMenu() {
        coordinator?.eventOccurred(with: .informationScreen)
    }
}
