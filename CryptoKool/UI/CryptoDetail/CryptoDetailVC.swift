//
//  CryptoDetailVC.swift
//  CryptoKool
//
//  Created by trungnghia on 20/02/2022.
//

import UIKit
import Combine

final class CryptoDetailVC: UIViewController, Coordinating {
    
    // MARK: Properties
    var coordinator: Coordinator?
    
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
    private var subscriptions = [AnyCancellable]()
    private var isFavorite = false
    var viewModel: CryptoDetailVM?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        viewModel?.fetchCryptoDetail()
        setupObserver()
        timer = Timer.scheduledTimer(timeInterval: fetchCycle, target: self, selector: #selector(callFetchData), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        CKLogger.info("Deinit CryptoDetailVC...")
    }
    
    private func setupObserver() {
        viewModel?.onCryptoDetailChange
            .sink(receiveValue: { [weak self] in
                self?.setupUI()
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
            }).store(in: &subscriptions)
    }
    
    // MARK: Helpers
    private func setupUI() {
        guard let viewModel = viewModel else {
            return
        }

        if let imageURL = viewModel.imageURL,
           let url = URL(string: imageURL) {
            imageView.backgroundColor = .tertiarySystemGroupedBackground
            loadImage(imageUrl: url)
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
    
    private func loadImage(imageUrl: URL) {
        viewModel?.imageRepository
            .getImage(imageUrl: imageUrl)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    //CKLog.info("Load image successfully")
                    break
                case .failure(let error):
                    CKLogger.error("Load image failure: \(error)")
                }
            } receiveValue: { [weak self] image in
                self?.imageView.image = image
            }.store(in: &subscriptions)
    }
    
    private func setupHyperlink(text: String, path: String) {
        linkTextView.text = text
        let text = linkTextView.text ?? ""
        let font = linkTextView.font
        let attributedString = NSMutableAttributedString.makeHyperlink(for: path, in: text, as: text)
        linkTextView.attributedText = attributedString
        linkTextView.font = font
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel?.getSymbol()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapFavoriteButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: Selectors
    @objc private func callFetchData() {
        CKLogger.info("Fetching crypto detail again...")
        viewModel?.fetchCryptoDetail()
    }
    
    @objc private func didTapFavoriteButton() {
        CKLogger.info("Did tap Favorite Button...")
        isFavorite.toggle()
        if isFavorite {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }
        
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
