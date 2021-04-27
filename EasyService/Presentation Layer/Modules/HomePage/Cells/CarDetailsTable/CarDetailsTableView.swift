//
//  CarDetailsTableView.swift
//  EasyService
//
//  Created by Михаил on 27.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

@IBDesignable
class CarDetailsTableView: UITableView, Configurable {
    typealias Model = Car
    func configure(_ model: Car) {
        markCell.detailTextLabel?.text = model.mark
        modelCell.detailTextLabel?.text = model.model
        bodyCell.detailTextLabel?.text = model.body
        gearCell.detailTextLabel?.text = model.gear
        engineCell.detailTextLabel?.text = String(model.engine)
        yearCell.detailTextLabel?.text = String(model.productionYear)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setLayouts()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayouts()
    }
    

    private lazy var markCell = cell()
    private lazy var modelCell = cell()
    private lazy var bodyCell = cell()
    private lazy var gearCell = cell()
    private lazy var engineCell = cell()
    private lazy var yearCell = cell()
    private lazy var cells = [markCell, modelCell, bodyCell, gearCell, engineCell, yearCell]
    func setLayouts() {
        backgroundColor = .clear
        dataSource = self
        allowsSelection = false
        tableFooterView = UIView(frame: .init(x: 0, y: 0, width: frame.width, height: 1))
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        markCell.textLabel?.text = "Марка"
        modelCell.textLabel?.text = "Модель"
        bodyCell.textLabel?.text = "Кузов"
        gearCell.textLabel?.text = "Трансмиссия"
        engineCell.textLabel?.text = "Объем двигателя"
        yearCell.textLabel?.text = "Год производства"
        
        reloadData(animated: true)
        heightAnchor.constraint(equalToConstant: contentSize.height).isActive = true
    }
    func cell() -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellDetails")
        cell.backgroundColor = .clear
        return cell
    }
}
extension CarDetailsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    
}
