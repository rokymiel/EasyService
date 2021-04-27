//
//  UIViewExtension.swift
//  EasyService
//
//  Created by Михаил on 19.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

extension UIView {
    func setBlur() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        clipsToBounds = true
        insertSubview(blurEffectView, at: 0)
        
    }
    
    @IBInspectable
    var squircle: Bool {
        get { return layer.cornerCurve == .continuous}
        set {
            if newValue {
                layer.cornerCurve = .continuous
            } else {
                layer.cornerCurve = .circular
            }
        }
    }
}
