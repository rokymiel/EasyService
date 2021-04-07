//
//  UIContainerView.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class UIContainerView: UIView {
    //    override func draw(_ rect: CGRect) {
    ////        // set the shadow of the view's layer
    ////        layer.backgroundColor = UIColor.clear.cgColor
    ////        layer.shadowColor = UIColor.black.cgColor
    ////        layer.shadowOffset = CGSize(width: 0, height: 1.0)
    ////        layer.shadowOpacity = 0.5
    ////        layer.shadowRadius = 20.0
    ////
    ////        // set the cornerRadius of the containerView's layer
    ////        containerView.layer.cornerRadius = cornerRadius
    ////        containerView.layer.masksToBounds = true
    ////
    ////        addSubview(containerView)
    ////
    ////        //
    ////        // add additional views to the containerView here
    ////        //
    ////
    ////        // add constraints
    ////        containerView.translatesAutoresizingMaskIntoConstraints = false
    ////
    ////        // pin the containerView to the edges to the view
    ////        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    ////        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    ////        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    ////        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    //    }
    //    private var shadowLayer: CAShapeLayer!
    //    private var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor
    //
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //
    //        if shadowLayer == nil {
    //            shadowLayer = CAShapeLayer()
    //
    //            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    //
    //            shadowLayer.shadowColor = UIColor.black.cgColor
    //            shadowLayer.shadowPath = shadowLayer.path
    //            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    //            shadowLayer.shadowOpacity = 0.5
    //            shadowLayer.shadowRadius = 3
    //
    //            layer.insertSublayer(shadowLayer, at: 0)
    //        }
    //    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     
     */
    
    /*
     Example of how to create a view that has rounded corners and a shadow.
     These cannot be on the same layer because setting the corner radius requires masksToBounds = true.
     When it's true, the shadow is clipped.
     It's possible to add sublayers and set their path with a UIBezierPath(roundedRect...), but this becomes difficult when using AutoLayout.
     Instead, we a containerView for the cornerRadius and the current view for the shadow.
     All subviews should just be added and constrained to the containerView
     */
    
    
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = backgroundColor
        
        addSubview(containerView)
        
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
    
}
