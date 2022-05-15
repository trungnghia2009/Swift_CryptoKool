//
//  CryptoListVCTableViewController.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import UIKit

final class CryptoListVC: UITableViewController {
    
    // MARK: Properties
    private let cryptoService =  CryptoService(coinGeckoService: CoinGeckoService())
    private var viewModel: CryptoListVM?
    private var timer: Timer?
    private let fetchCycle: Double = 30
    
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
        viewModel = CryptoListVM(service: cryptoService)
        viewModel?.fetchCryptoList()
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
                                                            action: #selector(didTapRightBarButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapLeftBarButton))
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    private func setTableView() {
        tableView.register(CryptoListCell.self, forCellReuseIdentifier: CryptoListCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupObserver() {
        viewModel?.cryptoList.signal.observe { [weak self] _ in
            CKLog.info(message: "Reload tableview...")
            self?.loadingIndicatorView.stopAnimating()
            self?.tableView.refreshControl?.endRefreshing()
            self?.stackView.isHidden = true
            self?.tableView.reloadData()
        }
    }
    
    private func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(callFetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func reset() {
        timer?.invalidate()
        timer = nil
    }
    
    
    // MARK: Selectors
    @objc private func didTapRightBarButton() {
        CKLog.info(message: "Did tap right bar button")
        navigationController?.pushViewController(InformationScreen(), animated: true)
    }
    
    @objc private func didTapLeftBarButton() {
        CKLog.info(message: "Did tap left bar button")
        reset()
    }
    
    @objc private func didTapSearchButton() {
        CKLog.info(message: "Did tap search button")
        let cryptoSearchVM = CryptoSearchVM(service: cryptoService)
        navigationController?.pushViewController(CryptoSearchVC(viewModel: cryptoSearchVM), animated: true)
    }
    
    @objc private func callFetchData() {
        CKLog.info(message: "Fetching crpto list again...")
        viewModel?.fetchCryptoList()
    }
}

// MARK: UITableViewDataSource
extension CryptoListVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoListCell.reuseIdentifier, for: indexPath) as? CryptoListCell,
              let viewModel = viewModel
        else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        let cryptoEntity = viewModel.cryptoAtIndex(indexPath.row)
        cell.viewModel = CryptoListCellVM(crypto: cryptoEntity)
        return cell
    }
}

// MARK: UITableViewDelegate
extension CryptoListVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let selectedItem = viewModel.cryptoAtIndex(indexPath.row)
        CKLog.info(message: "Did tap item with id: \(selectedItem.id)")
        
        let storyboard = UIStoryboard(name: "CryptoDetailVC", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CryptoDetailVC") as? CryptoDetailVC else {
            return
        }
        
        let cryptoDetailEntity = selectedItem.mapToDetailEntity()
        let cryptoDetailVM = CryptoDetailVM(service: cryptoService, entity: cryptoDetailEntity)
        controller.viewModel =  cryptoDetailVM
        navigationController?.pushViewController(controller, animated: true)
    }
}
