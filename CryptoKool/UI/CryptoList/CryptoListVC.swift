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
    
    private let favoriteButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .systemOrange
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.layer.cornerRadius = 25
        button.addShadow()
        button.addTarget(nil, action: #selector(didTapFavoriteButton), for: .touchUpInside)
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
        view.addSubview(favoriteButton)
        favoriteButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor,
                            paddingBottom: 30,
                            paddingRight: 20)
        
        view.addSubview(stackView)
        stackView.centerX(inView: view)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 200)
        
    }
    
    deinit {
        CKLogger.info("Deinit CryptoListVC...")
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: Helpers
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Top 100"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSearchButton))
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
                CKLogger.info("Reload tableview...")
                self.hideLoadingIndicatorView()
                self.configureSnapshot(for: self.viewModel.getCryptoList())
            }.store(in: &subscriptions)
        
        viewModel.onError
            .sink { [weak self] error in
                guard let self = self else { return }
                let info = AlertInfo(controller: self, title: "Error", content: error.description)
                self.coordinator?.eventOccurred(with: .alertSimpleScreen(info: info))
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
    @objc private func didTapSearchButton() {
        CKLogger.info("Did tap Info button")
        coordinator?.eventOccurred(with: .searchScreen)
    }
    
    @objc private func didTapMenuButton() {
        CKLogger.info("Did tap Menu button")
        coordinator?.eventOccurred(with: .menuScreen(delegate: self))
    }
    
    @objc private func didTapFavoriteButton() {
        CKLogger.info("Did tap Farovirte button")
        coordinator?.eventOccurred(with: .favoriteScreen)
    }
    
    @objc private func callFetchData() {
        CKLogger.info("Fetching crypto list again...")
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
}
