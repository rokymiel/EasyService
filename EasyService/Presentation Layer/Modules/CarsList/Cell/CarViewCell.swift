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
    
    private lazy var carImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "car_placeholder"))
        image.backgroundColor = .systemOrange
        image.contentMode = .scaleAspectFit
        image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        image.tintColor = .white
        return image
    }()
    
    private lazy var markLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var modelLabel = UILabel()
    private lazy var bodyLabel = UILabel()
    private lazy var yearLabel = UILabel()
    
    func configure(_ model: Car) {
        carImage.layer.cornerCurve = .continuous
        carImage.layer.cornerRadius = carImage.frame.height / 4
        carImage.contentScaleFactor = 2
        markLabel.text = model.mark
        modelLabel.text = model.model
        bodyLabel.text = model.body
        yearLabel.text = String(model.productionYear)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray4
        selectedBackgroundView = backgroundView
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    func setupUI() {
        contentView.addSubview(carImage)
        contentView.addSubview(markLabel)
        contentView.addSubview(modelLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(yearLabel)
        
        carImage.translatesAutoresizingMaskIntoConstraints = false
        markLabel.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        carImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        carImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        carImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        carImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        carImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        carImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        markLabel.bottomAnchor.constraint(equalTo: carImage.centerYAnchor).isActive = true
        markLabel.leadingAnchor.constraint(equalTo: carImage.trailingAnchor, constant: 10).isActive = true
        
        modelLabel.topAnchor.constraint(equalTo: carImage.centerYAnchor).isActive = true
        modelLabel.leadingAnchor.constraint(equalTo: carImage.trailingAnchor, constant: 10).isActive = true
        
        bodyLabel.leadingAnchor.constraint(equalTo: modelLabel.trailingAnchor, constant: 2).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: modelLabel.bottomAnchor).isActive = true
        
        yearLabel.centerYAnchor.constraint(equalTo: markLabel.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}
