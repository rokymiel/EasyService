//
//  RegistrationCollectionViewCell.swift
//  EasyService
//
//  Created by Михаил on 21.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class RegistrationCollectionViewCell: UICollectionViewCell, Configurable {
    typealias Model = Registration
    
    
    
    func configure(_ model: Registration) {
        statusLabel.text = model.status.text

        dayTextLabel.text = String(model.dateOfRegistration.get(.day))
        monthTextLabel.text = model.dateOfRegistration.month
        
        typeOfWorksLabel.text = model.typeOfWorks

    }
    
    @IBOutlet weak var dayTextLabel: UILabel!
    @IBOutlet weak var containerView: UIContainerView!
    @IBOutlet weak var monthTextLabel: UILabel!
    @IBOutlet weak var typeOfWorksLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var statusLabel: UIEdgeInsetLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.squircle = true
        statusLabel.layer.cornerRadius = 10
        statusLabel.layer.masksToBounds = true
        sizeToFit()
        print(containerView.squircle)
        print(containerView.layer.cornerCurve)
    }

}
