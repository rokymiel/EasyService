//
//  RegistrationCollectionViewCell.swift
//  EasyService
//
//  Created by Михаил on 21.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class RegistrationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIContainerView!
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
