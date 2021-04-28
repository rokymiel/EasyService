//
//  UIRoundedButton.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

@IBDesignable
class UIRoundedButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 15 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = cornerRadius
        if let color = backgroundColor?.cgColor {
            layer.backgroundColor = color
        } else {
            layer.backgroundColor = UIColor.orange.cgColor
            tintColor = UIColor.white
        }
    }
}
