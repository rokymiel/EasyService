//
//  MileageChartViewCell.swift
//  EasyService
//
//  Created by Михаил on 22.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import Charts

class MileageChartViewCell: UITableViewCell, Configurable {
    
    typealias Model = [(date: Date, mileage: Int)]
    
    private let lineChart = LineChartView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lineChart.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lineChart.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
    }
    func configure(_ model: Model) {
        var entries = [ChartDataEntry]()
        
        for  (i, (_, mileage)) in model.enumerated() {
            entries.append(.init(x: Double(i), y: Double(mileage)))
        }
        lineChart.data = LineChartData(dataSet: LineChartDataSet(entries))
        
    }
    
}
