//
//  CryptoDetailVC.swift
//  CryptoKool
//
//  Created by trungnghia on 20/02/2022.
//

import UIKit

final class CryptoDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var priceChangePercentage24hLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var high24hLabel: UILabel!
    @IBOutlet weak var low24hLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    private var timer: Timer?
    private let fetchCycle: Double = 30
    var viewModel: CryptoDetailVM?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchCryptoDetail()
        navigationItem.title = viewModel?.getSymbol()
        setupObserver()
        timer = Timer.scheduledTimer(timeInterval: fetchCycle, target: self, selector: #selector(callFetchData), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        CKLog.info(message: "Deinit CryptoDetailVC...")
    }
    
    private func setupObserver() {
        viewModel?.cryptoDetail.signal.observe { [weak self] _ in
            self?.setupUI()
        }
    }
    
    // MARK: Helpers
    private func setupUI() {
        guard let viewModel = viewModel else {
            return
        }

        if let imageURL = viewModel.imageURL,
           let url = URL(string: imageURL) {
            imageView.backgroundColor = .tertiarySystemGroupedBackground
            imageView.sd_setImage(with: url)
        }
        
        currentPriceLabel.text = viewModel.currentPrice
        
        switch viewModel.checkPrice {
        case .increasing:
            priceChangePercentage24hLabel.textColor = .systemGreen
        case .decreasing:
            priceChangePercentage24hLabel.textColor = .red
        case .zero:
            break
        }
        priceChangePercentage24hLabel.text = viewModel.priceChangePercentage24h
        
        setupHyperlink(text: viewModel.homepageLink, path: viewModel.homepageLink)
        high24hLabel.text = viewModel.high24h
        low24hLabel.text = viewModel.low24h
        rankLabel.text = viewModel.rank
    }
    
    private func setupHyperlink(text: String, path: String) {
        linkTextView.text = text
        let text = linkTextView.text ?? ""
        let font = linkTextView.font
        let attributedString = NSMutableAttributedString.makeHyperlink(for: path, in: text, as: text)
        linkTextView.attributedText = attributedString
        linkTextView.font = font
    }
    
    // MARK: Selectors
    @objc private func callFetchData() {
        CKLog.info(message: "Fetching crypto detail again...")
        viewModel?.fetchCryptoDetail()
    }
}

private extension NSAttributedString {
    static func makeHyperlink(for path: String, in string: String, as substring: String) -> NSAttributedString {
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: substringRange)
        return attributedString
    }
}
