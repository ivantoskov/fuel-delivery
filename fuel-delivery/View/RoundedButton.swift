//
//  RoundedButton.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        self.layer.cornerRadius = 10.0
        self.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
}
