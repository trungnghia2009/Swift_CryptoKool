//
//  MenuSection.swift
//  Menu_Expand_Collapse
//
//  Created by trungnghia on 07/12/2022.
//

import UIKit

class MenuSection: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MenuSection.self)
    
    @IBOutlet private weak var menuImage: UIImageView!
    @IBOutlet private weak var menuTitleLabel: UILabel!
    @IBOutlet private weak var expandCollapseImage: UIImageView!
    
    private var isOpened = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuImage.tintColor = .label
    }
    
    private func configureUI(menu: CryptoMenuModel) {
        menu.options.count == 0 ?
            (expandCollapseImage.isHidden = true) :
            (selectionStyle = .none)
        isOpened ?
            (expandCollapseImage.image = UIImage(systemName: "arrowtriangle.up.fill")) :
            (expandCollapseImage.image = UIImage(systemName: "arrowtriangle.down.fill"))
    }
    
    func configure(menu: CryptoMenuModel) {
        self.isOpened = menu.isOpened
        configureUI(menu: menu)
        menuImage.image = UIImage(systemName: menu.title.menuImage)
        menuTitleLabel.text = menu.title.text
    }
}
