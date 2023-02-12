//
//  MenuViewController.swift
//  Menu_Expand_Collapse
//
//  Created by trungnghia on 07/12/2022.
//

import UIKit
import MessageUI

protocol CryptoMenuViewControllerDelegate: AnyObject {
    func didTapSearchMenu()
}

class CryptoMenuViewController: UIViewController, Coordinating {
    
    // MARK: - Properties
    var coordinator: Coordinator?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UINib(nibName: MenuSection.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MenuSection.reuseIdentifier)
        tableView.register(UINib(nibName: MenuCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MenuCell.reuseIdentifier)
        return tableView
    }()
    
    private let viewModel = CryptoMenuViewModel()
    private var sections = [CryptoMenuModel]()
    weak var delegate: CryptoMenuViewControllerDelegate?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = viewModel.sections
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Helpers
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
    
    // MARK: Selectors
    @objc private func didTapRightBarBtn() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UITableViewDataSource
extension CryptoMenuViewController: UITableViewDataSource {
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
            cell.configure(title: title.text)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension CryptoMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
            
            // Handle navigation here
            if let menu = viewModel.createMainMenuWithoutSubMenu(menu: sections[indexPath.section].title.rawValue) {
                CKLogger.info("Did tap menu: \(menu.rawValue)")
                switch menu {
                case .favorite:
                    coordinator?.eventOccurred(with: .favoriteScreen)
                case .about:
                    coordinator?.eventOccurred(with: .informationScreen)
                case .report:
                    coordinator?.eventOccurred(with: .emailScreen(controller: self, delegate: self))
                case .exit:
                    let title = CKLanguage.text("alert_exit_title", comment: "Exit")
                    let content = CKLanguage.text("alert_exit_description", comment: "Would you like to exit?")
                    let alertInfo = AlertInfo(controller: self, title: title, content: content)
                    coordinator?.eventOccurred(with: .alertOptionsScreen(info: alertInfo) {
                        RootViewManager.shared.show(view: .firstScreen)
                    })
                }
            }
        } else {
            
            // Handle navigation here
            let cellName = sections[indexPath.section].options[indexPath.row - 1]
            switch cellName {
            case .homeTop100:
                print("Did tap cell: \(cellName.rawValue)")
                navigationController?.popViewController(animated: true)
            case .homeSearch:
                print("Did tap cell: \(cellName.rawValue)")
                navigationController?.popViewController(animated: false, completion: { [weak self] in
                    self?.delegate?.didTapSearchMenu()
                })
            }
            
        }
        
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension CryptoMenuViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
