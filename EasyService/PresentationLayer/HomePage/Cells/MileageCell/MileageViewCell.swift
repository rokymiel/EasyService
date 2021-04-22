//
//  MileageViewCell.swift
//  EasyService
//
//  Created by Михаил on 22.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

private extension UIImage {
    static var verified: UIImage? {
        UIImage(systemName: "checkmark.circle.fill")
    }
    static var notVerified: UIImage? {
        UIImage(systemName: "xmark.octagon.fill")
    }
}

class MileageViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    
    private let mileageLabel = UILabel()
    private let metricsLabel = UILabel()
    
    private let statusImage = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(titleLabel)
        addSubview(mileageLabel)
        addSubview(metricsLabel)
        addSubview(statusImage)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mileageLabel.translatesAutoresizingMaskIntoConstraints = false
        metricsLabel.translatesAutoresizingMaskIntoConstraints = false
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mileageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        metricsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        statusImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        statusImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        statusImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        statusImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        metricsLabel.trailingAnchor.constraint(equalTo: statusImage.leadingAnchor, constant: -5).isActive = true
        mileageLabel.trailingAnchor.constraint(equalTo: metricsLabel.leadingAnchor, constant: -2).isActive = true
        
        titleLabel.text = "Текущий пробег"
        metricsLabel.text = "км"
        
        statusImage.image = .verified
        statusImage.tintColor = .systemGreen
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
