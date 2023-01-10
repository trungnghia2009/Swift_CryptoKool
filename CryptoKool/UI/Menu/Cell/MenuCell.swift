//
//  MenuCell.swift
//  Menu_Expand_Collapse
//
//  Created by trungnghia on 07/12/2022.
//

import UIKit

class MenuCell: UITableViewCell {

    static let reuseIdentifier = String(describing: MenuCell.self)

    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
