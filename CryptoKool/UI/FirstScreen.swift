//
//  FirstScreen.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import UIKit
import Lottie

final class FirstScreen: UIViewController {
    
    // MARK: Properties
    private let heartAnimationView = AnimationView(animation: Animation.named("love"))
    private let onboardingKey = "onBoarding"
    
    private let startNowButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.setTitle(NSLocalizedString("Start_now", comment: "Start now"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 25
        button.addTarget(nil, action: #selector(didTapStartNowButton), for: .touchUpInside)
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.textColor = .systemGray
        label.text = "APIs provided by"
        return label
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: onboardingKey) == true {
            PresenterManager.shared.show(vc: .cryptoListScreen)
        }
        setupGradientLayer(fromColor: .white, toColor: .orange)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        heartAnimationView.stop()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        logoImageView.setDimensions(width: UIScreen.main.bounds.width - 20, height: 100)
        logoImageView.center(inView: view)
        logoImageView.image = UIImage(named: "coinGecko_logo")
        
        view.addSubview(titleLabel)
        titleLabel.anchor(bottom: logoImageView.topAnchor, paddingBottom: 20)
        titleLabel.centerX(inView: view)
        
        view.addSubview(startNowButton)
        startNowButton.setDimensions(width: UIScreen.main.bounds.width - 20, height: 50)
        startNowButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        startNowButton.centerX(inView: view)
        
    }
    
    private func setupAnimation() {
        heartAnimationView.animationSpeed = 2
        heartAnimationView.tintColor = .orange
        heartAnimationView.loopMode = .loop
        heartAnimationView.contentMode = .scaleAspectFit
        heartAnimationView.frame = CGRect(x: (view.frame.size.width - 200) / 2, y: 50, width: 200, height: 200)
        view.addSubview(heartAnimationView)
        heartAnimationView.play()
    }
    
    // MARK: Selectors
    @objc private func didTapStartNowButton() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
        heartAnimationView.stop()
        PresenterManager.shared.show(vc: .cryptoListScreen)
    }
}
