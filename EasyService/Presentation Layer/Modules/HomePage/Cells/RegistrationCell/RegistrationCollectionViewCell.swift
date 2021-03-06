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
        statusLabel.backgroundColor = model.status.color
        statusLabel.textColor = model.status.tintColor
        dayTextLabel.text = String(model.dateOfRegistration.get(.day))
        monthTextLabel.text = model.dateOfRegistration.month
        
        typeOfWorksLabel.text = model.typeOfWorks
        
    }
    
    @IBOutlet weak var dayTextLabel: UILabel!
    @IBOutlet weak var containerView: UIContainerView!
    @IBOutlet weak var monthTextLabel: UILabel!
    @IBOutlet weak var typeOfWorksLabel: UILabel!
    @IBOutlet weak var statusLabel: UIEdgeInsetLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.squircle = true
        statusLabel.layer.cornerRadius = 10
        statusLabel.layer.masksToBounds = true
        sizeToFit()
    }
    
    private let group = DispatchGroup()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        group.enter()
        UIView.animate(withDuration: 0.2) {
            self.transform = .init(scaleX: 0.85, y: 0.85)
        } completion: { _ in
            self.group.leave()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        group.notify(queue: .main) {
            UIView.animate(withDuration: 0.2) {
                self.transform = .init(scaleX: 1, y: 1)
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        group.notify(queue: .main) {
            UIView.animate(withDuration: 0.2) {
                self.transform = .init(scaleX: 1, y: 1)
            }
        }
    }
}
