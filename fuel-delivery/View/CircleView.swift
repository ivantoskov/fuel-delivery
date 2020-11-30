//
//  CircleView.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 30/11/2020.
//

import Foundation

import UIKit

class CircleView: UIView {
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
