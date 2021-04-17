//
//  CarViewCell.swift
//  EasyService
//
//  Created by Михаил on 14.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class CarViewCell: UITableViewCell, Configurable {
    typealias Model = Car
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    func configure(_ model: Car) {
        carImage.layer.cornerCurve = .continuous
        carImage.layer.cornerRadius = carImage.frame.height/4
        carImage.contentScaleFactor = 2
        markLabel.text = model.mark
        modelLabel.text = model.model
        bodyLabel.text = model.body
        yearLabel.text = String(model.productionYear)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray4
        selectedBackgroundView = backgroundView
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemGray6
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
