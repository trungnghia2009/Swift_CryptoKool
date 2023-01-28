//
//  MenuViewController.swift
//  Menu_Expand_Collapse
//
//  Created by trungnghia on 07/12/2022.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didTapSearchMenu()
    func didTapInfomationMenu()
}

class MenuViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UINib(nibName: MenuSection.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MenuSection.reuseIdentifier)
        tableView.register(UINib(nibName: MenuCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MenuCell.reuseIdentifier)
        return tableView
    }()
    
    private let viewModel = MenuViewModel()
    private var sections = [MenuModel]()
    weak var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = viewModel.sections
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func configureNavigationBar() {
        title = "Menu"
        navigationItem.hidesBackButton = true
        let rightBarBtn = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapRightBarBtn))
        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.frame = view.bounds
    }
    
    @objc private func didTapRightBarBtn() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Setup section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuSection.reuseIdentifier, for: indexPath) as? MenuSection else {
                return UITableViewCell()
            }
            let menuModel = sections[indexPath.section]
            cell.configure(menu: menuModel)
            return cell
        } else {
            // Setup cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseIdentifier, for: indexPath) as? MenuCell else {
                return UITableViewCell()
            }
            let title = sections[indexPath.section].options[indexPath.row - 1]
            cell.configure(title: title.rawValue)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
            
            // Handle navigation here
            if let menu = viewModel.createMainMenuWithoutSubMenu(menu: sections[indexPath.section].title.rawValue) {
                switch menu {
                case .favorite:
                    print("Did tap menu: \(menu.rawValue)")
                    navigationController?.popViewController(animated: true)
                case .about:
                    print("Did tap menu: \(menu.rawValue)")
                    navigationController?.popViewController(animated: false, completion: { [weak self] in
                        self?.delegate?.didTapInfomationMenu()
                    })
                }
            }
        } else {
            
            // Handle navigation here
            let cellName = sections[indexPath.section].options[indexPath.row - 1]
            switch cellName {
            case .homeFeature1:
                print("Did tap cell: \(cellName.rawValue)")
                navigationController?.popViewController(animated: true)
            case .homeFeature2:
                print("Did tap cell: \(cellName.rawValue)")
                navigationController?.popViewController(animated: false, completion: { [weak self] in
                    self?.delegate?.didTapSearchMenu()
                })
            }
            
        }
        
    }
}

