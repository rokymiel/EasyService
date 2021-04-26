//
//  UIYearPickerDelegate.swift
//  EasyService
//
//  Created by Михаил on 10.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class UIYearPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    private let minYear: Int
    private let maxYear: Int
    
    init(min: Int, max: Int) {
        minYear = min
        maxYear = max
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxYear - minYear + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + minYear)
    }
    
    
}
