//
//  RoundedView.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import UIKit

class RoundedView: UIView {

    override func layoutSubviews() {
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.5)
        self.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.5)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
    }

}
