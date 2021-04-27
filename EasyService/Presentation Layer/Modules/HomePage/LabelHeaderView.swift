//
//  LabelHeaderView.swift
//  EasyService
//
//  Created by Михаил on 22.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class LabelHeaderView: UITableViewHeaderFooterView, Configurable {
    func configure(_ model: Model) {
        label.text = model.header
        if let action = model.action {
            actionButton.isHidden = false
            self.action = action
            if let text = model.actionText {
                actionButton.setTitle(text, for: .normal)
            }
            if let image = model.actionImage {
                actionButton.setImage(image, for: .normal)
            }
            
        } else {
            actionButton.isHidden = true
            self.action = nil
        }
    }
    
    var action: (() -> Void)?
    
    struct Model {
        let header: String
        let action: (() -> Void)?
        let actionText: String?
        let actionImage: UIImage?
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = .systemBackground
        
        actionButton.tintColor = .systemOrange
        actionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        actionButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        label.numberOfLines = 0
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        contentView.addSubview(actionButton)
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        label.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -20).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        actionButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    @objc func buttonClicked() {
        action?()
    }
    
    //    Only override draw() if you perform custom drawing.
    //    An empty implementation adversely affects performance during animation.
    //    override func draw(_ rect: CGRect) {
    
    //    }
    
}
