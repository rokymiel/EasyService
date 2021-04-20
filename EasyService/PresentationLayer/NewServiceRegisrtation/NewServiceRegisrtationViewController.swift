//
//  NewServiceRegisrtationViewController.swift
//  EasyService
//
//  Created by Михаил on 18.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class NewServiceRegisrtationViewController: UITableViewController {
    
    private var registrationService: IRegistrationService!
    private var presentationAssembly: IPresentationAssembly!
    private var service: Service!
    private var car: Car!
    
    private lazy var chooser: ItemInListChooserViewController = presentationAssembly.buildItemInListChooserViewController()
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var typeOfWorksTextField: UITextField!
    @IBOutlet weak var carCell: CarViewCell!
    
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        f.locale = .init(identifier: "ru")
        return f
    }()
    let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        f.locale = .init(identifier: "ru")
        return f
    }()
    
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    class func sInit(service: Service, car: Car, registrationService: IRegistrationService, presentationAssembly: IPresentationAssembly) -> NewServiceRegisrtationViewController {
        let contraller = UIStoryboard.newServiceRegisrtation.instantiate(self)
        contraller.registrationService = registrationService
        contraller.presentationAssembly = presentationAssembly
        contraller.service = service
        contraller.car = car
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        carCell.configure(car)
        addDateToolbar()
        addTimeToolbar()
    }
    
    func addDateToolbar() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.sizeToFit()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        if #available(iOS 14.0, *) {
            dateTextField.inputView?.frame = CGRect(x: 0, y: 0, width: dateTextField.inputView?.frame.width ?? 0, height: 380)
        }
    }
    
    func addTimeToolbar() {
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 10
        timePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        timeTextField.inputAccessoryView = toolbar
        timeTextField.inputView = timePicker
    }
    
    @objc func doneTimePicker() {
        timeTextField.text = timeFormatter.string(from: timePicker.date)
        self.view.endEditing(false)
    }
    @objc func doneDatePicker() {
        var calender = Calendar.current
        calender.locale = Locale(identifier: "ru")
        let dayIdx = (calender.component(.weekday, from: datePicker.date) + 5) % 7
        timeTextField.isEnabled = true
        if setTime(dayIdx) {
            dateTextField.text = dateFormatter.string(from: datePicker.date)
            self.view.endEditing(false)
        }
    }
    
    @objc func cancelPicker() {
        dateTextField.setPlaceholder()
        self.view.endEditing(false)
    }
    func setTime(_ idx: Int) -> Bool {
        //        let time = service.workTime[idx]
        
        let interval = service.workTime[idx].split(separator: "-")
        if interval.count == 2 {
            let start = timeFormatter.date(from: String(interval[0]))
            let end = timeFormatter.date(from: String(interval[1]))
            timePicker.minimumDate = start
            timePicker.maximumDate = end
            return true
        } else {
            timeTextField.isEnabled = false
            showAlert(with: "В выбранный день сервис не работает")
            return false
        }
        
        
        //        let inStr = "16:50"
        //        let date = formatter.dateFromString(inStr)!
        //        let outStr = formatter.stringFromDate(date)
        //        println(outStr) // -> outputs 04:50
        
    }
    
    @IBAction func typeOfWorksChoose(_ sender: Any) {
        chooser.items = ["ТО", "Ремонт", "Замена шин"]
        chooser.itemChosenHandler = { [weak self] str in
            self?.typeOfWorksTextField.text = str
        }
        present(chooser, animated: true)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
        guard let type = typeOfWorksTextField.text, !type.isBlank(),
            let date = dateTextField.text, !date.isBlank(),
            let time = timeTextField.text, !time.isBlank()
            else {
                typeOfWorksTextField.setPlaceholder(color: .systemRed)
                dateTextField.setPlaceholder(color: .systemRed)
                timeTextField.setPlaceholder(color: .systemRed)
                return
        }
        
    }
    
}
