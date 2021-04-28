//
//  StatusCollectionViewCell.swift
//  EasyService
//
//  Created by Михаил on 24.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class StatusCollectionViewCell: UICollectionViewCell, Configurable {
    func configure(_ model: (status: Registration.Status, isCurrent: Bool)) {
        statusLabel.text = model.status.text
        statusLabel.layer.opacity = model.isCurrent ? 1 : 0.3
        statusLabel.backgroundColor = model.status.color
        statusLabel.textColor = model.status.tintColor
    }
    
    typealias Model = (status: Registration.Status, isCurrent: Bool)
    
    @IBOutlet weak var statusLabel: UIEdgeInsetLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        statusLabel.layer.cornerRadius = 10
        statusLabel.layer.masksToBounds = true
        // Initialization code
    }

}
