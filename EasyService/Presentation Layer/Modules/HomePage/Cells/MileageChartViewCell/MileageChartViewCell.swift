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
        chart.xAxis.labelFont = .systemFont(ofSize: 7)
        return chart
    }()
    private var container = UIContainerView(frame: .zero)
    
    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(container)
        container.backgroundColor = .secondarySystemGroupedBackground
        container.squircle = true
        container.updateView()
        container.addSubview(lineChart)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
        lineChart.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10).isActive = true
        lineChart.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10).isActive = true
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        
        lineChart.xAxis.valueFormatter = self
        
    }
    
    var mileage = Model()
    
    func configure(_ model: Model) {
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
        let index = Int(value)
        if Double(index) == value {
            let date = mileage[Int(value)].date
            if date.get(.year) == Date().get(.year) {
                return date.dayMonthDate
            }
            return date.fullDate
        }
        return ""
    }
}
