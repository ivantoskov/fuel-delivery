//
//  CircleImage.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
