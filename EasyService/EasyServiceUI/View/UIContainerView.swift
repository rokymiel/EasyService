//
//  UIContainerView.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

@IBDesignable
class UIContainerView: UIView {
    let containerView = UIView()
    
    @IBInspectable
    var cornerRadius: CGFloat = 15 {
        didSet {
            containerView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 10 {
        didSet {
            layer.shadowRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var hasShadow: Bool = true {
        didSet {
            if hasShadow {
                layer.shadowOpacity = 0.3
            } else {
                layer.shadowOpacity = 0
            }
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
    
    func updateView() {
        let backgroundColor = self.backgroundColor
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        if hasShadow {
            layer.shadowColor = UIColor.black.cgColor
        }
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.shadowRadius = shadowRadius
        
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = backgroundColor
    }
    
    private func layoutView() {
       
        updateView()
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
    override func addSubview(_ view: UIView) {
        containerView.addSubview(view)
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
