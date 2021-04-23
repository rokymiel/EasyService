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
    
    typealias Model = [Mileage]
    
    private let lineChart: LineChartView = {
        let chart = LineChartView()
        chart.leftAxis.enabled = false
        chart.xAxis.labelPosition = .bottom
        
        chart.animate(xAxisDuration: 1)
        
        return chart
    }()
    
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
        print("COMN", model.count)
        var entries = [ChartDataEntry]()
        
        for  (i, mileage) in model.enumerated() {
            entries.append(.init(x: Double(i), y: Double(mileage.value)))
        }
        let set = LineChartDataSet(entries)
        set.circleColors = [.orange]
        lineChart.data = LineChartData(dataSet: set)
        
    }
}

extension MileageChartViewCell: ChartViewDelegate {
    
}
