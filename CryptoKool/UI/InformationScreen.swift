//
//  InformationScreen.swift
//  CryptoKool
//
//  Created by trungnghia on 19/02/2022.
//

import UIKit
import Lottie

final class InformationScreen: UIViewController {

    // MARK: Properties
    private let waitingAnimationView = AnimationView(animation: Animation.named("cryptocurrency"))
    
    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .systemGray
        label.text = "Created by Tran Trung nghia"
        return label
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .systemGray
        label.text = "Version 1.0"
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapVersionLabel))
        tapGesture.numberOfTapsRequired = 5
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(waitingAnimationView)
        waitingAnimationView.center(inView: view)
        
        view.addSubview(copyrightLabel)
        copyrightLabel.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
        copyrightLabel.centerX(inView: view)
        
        view.addSubview(versionLabel)
        versionLabel.anchor(bottom: waitingAnimationView.topAnchor, paddingBottom: -100)
        versionLabel.centerX(inView: view)
    }
    
    // MARK: Helpers
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Infomation"
    }
    
    private func setupAnimation() {
        waitingAnimationView.animationSpeed = 1
        waitingAnimationView.loopMode = .loop
        waitingAnimationView.contentMode = .scaleAspectFit
        waitingAnimationView.setDimensions(width: UIScreen.main.bounds.width, height: 500)
        waitingAnimationView.play()
    }
    
    // MARK: Selectors
    @objc private func didTapVersionLabel() {
        CKLog.info(message: "Did tap version label...")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        showToast(message: "App will shutdow after 5s...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            exit(0)
        }
    }
}
