//
//  UIRoundedButton.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class UIRoundedButton: UIButton {


    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 15
        layer.backgroundColor = UIColor.orange.cgColor
        frame.size = CGSize(width: frame.width, height: 50)
        tintColor = UIColor.white
    }

}
