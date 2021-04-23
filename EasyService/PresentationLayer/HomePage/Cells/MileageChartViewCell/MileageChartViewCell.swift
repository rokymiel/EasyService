//
//  MileageChartViewCell.swift
//  EasyService
//
//  Created by Михаил on 22.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import Charts

final class MileageChartViewCell: UITableViewCell, Configurable {
    
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
        
        lineChart.xAxis.valueFormatter = self
        
    }
    
    var mileage = Model()
    
    func configure(_ model: Model) {
        print("COMN", model.count)
        var entries = [ChartDataEntry]()
        var colors = [UIColor]()
        mileage = model.sorted(by: { $0.date < $1.date })
        for  (i, mileage) in mileage.enumerated() {
            entries.append(.init(x: Double(i), y: Double(mileage.value)))
            colors.append(mileage.isVerified ? .systemGreen : .systemRed)
        }
        let set = LineChartDataSet(entries)
        set.mode = .cubicBezier
        set.lineWidth = 2
        set.colors = [.orange]
        set.circleColors = colors
        lineChart.data = LineChartData(dataSet: set)
        
    }
}

extension MileageChartViewCell: IAxisValueFormatter {
    
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        let date = mileage[Int(value)].date
        if date.get(.year) == Date().get(.year) {
            return date.dayMonthDate
        }
        return date.fullDate
    }
}
