//
//  UIUnderlinedTextField.swift
//  EasyService
//
//  Created by Михаил on 09.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class UIUnderlinedTextField: UITextField{
    
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
        if layer.sublayers?.contains(border) ?? false{
            border.removeFromSuperlayer()
        }
        border.path = UIBezierPath.init(
            rect: CGRect.init(x: 0, y: self.bounds.height - 2,
                              width: self.bounds.width, height: 2)).cgPath
        self.layer.insertSublayer(border, at: 10)
        
        //        var bottomLine = CALayer()
        //        bottomLine.frame = CGRectMake(0.0, view.frame.height - 1, view.frame.width, 1.0)
        //        bottomLine.backgroundColor = UIColor.whiteColor().CGColor
        //        myTextField.borderStyle = UITextBorderStyle.None
        //        myTextField.layer.addSublayer(bottomLine)
        
    }
    private func setUnderLineColor() {
        border.fillColor = lineColor.cgColor
    }
}
