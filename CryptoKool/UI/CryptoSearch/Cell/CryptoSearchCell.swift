//
//  CryptoSearchCell.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import UIKit
import SDWebImage

final class CryptoSearchCell: UITableViewCell {

    static let reuseIdentifier = String(describing: CryptoSearchCell.self)
    var viewModel: CryptoSearchCellVM? {
        didSet {
            setup()
        }
    }
    
    // MARK: Properties
    private let cryptoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.setDimensions(width: 40, height: 40)
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.image = UIImage(named: "launchScreenImage")
        return iv
    }()
    
    private let cryptoNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.text = "Helium (HNT)"
        return label
    }()
    
    private let cryptoRankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cryptoImageView)
        cryptoImageView.centerY(inView: self, left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft: 15)
        
        let nameStack = UIStackView(arrangedSubviews: [cryptoNameLabel, cryptoRankLabel])
        nameStack.axis = .vertical
        nameStack.spacing = 5
        nameStack.alignment = .leading
        addSubview(nameStack)
        nameStack.centerY(inView: self, left: cryptoImageView.rightAnchor, paddingLeft: 12)
        nameStack.anchor(right: self.rightAnchor, paddingRight: 90)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helper
    private func setup() {
        guard let viewModel = viewModel else { return }
        cryptoNameLabel.text = viewModel.cryptoName
        cryptoRankLabel.text = viewModel.rank
        
        if let imageURL = viewModel.imageURL,
           let url = URL(string: imageURL) {
            cryptoImageView.backgroundColor = .clear
            cryptoImageView.sd_setImage(with: url)
        }
    }
}
