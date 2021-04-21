//
//  UIContainerView.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class UIContainerView: UIView {
    let containerView = UIView()
    
    @IBInspectable
    var cornerRadius: CGFloat = 15 {
        didSet {
            layer.shadowRadius = cornerRadius
            containerView.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        let backgroundColor = self.backgroundColor
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = cornerRadius
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = backgroundColor
        insertSubview(containerView, at: 0)
              
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    override var squircle: Bool {
        get { return containerView.layer.cornerCurve == .continuous}
        set {
            if newValue {
                containerView.layer.cornerCurve = .continuous
            } else {
                containerView.layer.cornerCurve = .circular
            }
        }
    }
}
