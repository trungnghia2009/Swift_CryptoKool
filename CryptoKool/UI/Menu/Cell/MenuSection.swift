//
//  MenuSection.swift
//  Menu_Expand_Collapse
//
//  Created by trungnghia on 07/12/2022.
//

import UIKit

class MenuSection: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MenuSection.self)

    var model: MenuModel? {
        didSet {
            configure()
        }
    }
    
    @IBOutlet private weak var menuImage: UIImageView!
    @IBOutlet private weak var menuTitleLabel: UILabel!
    @IBOutlet private weak var expandCollapseImage: UIImageView!
    
    private var isOpened = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuImage.tintColor = .label
    }
    
    private func configureUI() {
        model?.options.count == 0 ?
            (expandCollapseImage.isHidden = true) :
            (selectionStyle = .none)
        isOpened ?
            (expandCollapseImage.image = UIImage(systemName: "arrowtriangle.up.fill")) :
            (expandCollapseImage.image = UIImage(systemName: "arrowtriangle.down.fill"))
    }
    
    func configure() {
        guard let model = model else { return }
        self.isOpened = model.isOpened
        configureUI()
        menuImage.image = UIImage(systemName: model.title.menuImage)
        menuTitleLabel.text = model.title.rawValue
    }
}
