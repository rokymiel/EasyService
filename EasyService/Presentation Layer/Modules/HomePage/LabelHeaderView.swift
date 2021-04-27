//
//  LabelHeaderView.swift
//  EasyService
//
//  Created by Михаил on 22.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class LabelHeaderView: UITableViewHeaderFooterView, Configurable {
    func configure(_ model: String) {
        label.text = model
    }
    
    typealias Model = String
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        return label
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
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    //    Only override draw() if you perform custom drawing.
    //    An empty implementation adversely affects performance during animation.
    //    override func draw(_ rect: CGRect) {
    
    //    }
   
}
