//
//  ActionButton.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(touchUp), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchUp() {
        Helpers.shared.addHapticFeedback()
    }
}
