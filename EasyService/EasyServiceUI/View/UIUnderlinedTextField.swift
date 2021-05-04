//
//  UIUnderlinedTextField.swift
//  EasyService
//
//  Created by Михаил on 09.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class UIUnderlinedTextField: UITextField {
    
    let border = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addUnderLine()
        setUnderLineColor()
    }
    
    var lineColor: UIColor = .orange {
        didSet {
            setUnderLineColor()
        }
    }
    
    private func addUnderLine() {
        if layer.sublayers?.contains(border) ?? false {
            border.removeFromSuperlayer()
        }
        border.path = UIBezierPath(
            rect: .init(x: 0, y: self.bounds.height - 2,
                        width: self.bounds.width, height: 2)).cgPath
        self.layer.insertSublayer(border, at: 10)
    }
    
    private func setUnderLineColor() {
        border.fillColor = lineColor.cgColor
    }
}
