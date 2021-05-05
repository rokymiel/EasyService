//
//  NewServiceRegisrtationViewController.swift
//  EasyService
//
//  Created by Михаил on 18.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import MapKit

class NewServiceRegisrtationViewController: UITableViewController {
    
    private var registrationService: IRegistrationService!
    private var presentationAssembly: IPresentationAssembly!
    private var service: Service!
    private var car: Car!
    private var userId: String!
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var serviceLocationMap: MKMapView!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var typeOfWorksTextField: UITextField!
    @IBOutlet weak var carCell: CarViewCell!
    @IBOutlet weak var notesTextView: UITextView!
    
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    class func sInit(userId: String,
                     service: Service,
                     car: Car,
                     registrationService: IRegistrationService,
                     presentationAssembly: IPresentationAssembly) -> NewServiceRegisrtationViewController {
        let contraller = UIStoryboard.newServiceRegisrtation.instantiate(self)
        contraller.registrationService = registrationService
        contraller.presentationAssembly = presentationAssembly
        contraller.service = service
        contraller.car = car
        contraller.userId = userId
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая запись"
        navigationController?.navigationBar.barTintColor = tableView.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        addCloseItem()
        hideKeyboardWhenTappedAround()
        carCell.configure(car)
        serviceNameLabel.text = service.name
        addressLabel.text = service.address
        let annotation = MKPointAnnotation()
        annotation.coordinate = .init(latitude: service.location.latitude, longitude: service.location.longitude)
        serviceLocationMap.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.serviceLocationMap.setRegion(region, animated: true)
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
        timeTextField.text = timePicker.date.time
        self.view.endEditing(false)
    }
    
    @objc func doneDatePicker() {
        var calender = Calendar.current
        calender.locale = Locale(identifier: "ru")
        let dayIdx = (calender.component(.weekday, from: datePicker.date) + 5) % 7
        timeTextField.isEnabled = true
        if setTime(dayIdx) {
            dateTextField.text = datePicker.date.fullDate
            self.view.endEditing(false)
        }
    }
    
    @objc func cancelPicker() {
        dateTextField.setPlaceholder()
        self.view.endEditing(false)
    }
    
    func setTime(_ idx: Int) -> Bool {
        let interval = service.workTime[idx].split(separator: "-")
        if interval.count == 2 {
            let start = DateFormatter.timeFormatter().date(from: String(interval[0]))
            let end = DateFormatter.timeFormatter().date(from: String(interval[1]))
            timePicker.minimumDate = start
            timePicker.maximumDate = end
            return true
        } else {
            timeTextField.isEnabled = false
            showAlert(with: "В выбранный день сервис не работает")
            return false
        }
    }
    
    @IBAction func typeOfWorksChoose(_ sender: Any) {
        let chooser: ItemInListChooserViewController = presentationAssembly.buildItemInListChooserViewController()
        chooser.items = service.workTypes
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
        guard let carID = car.identifier,
              let resultDate = DateFormatter.fullDateWithTimeFormatter().date(from: "\(date) \(time)"),
              let serviceId = service.identifier else {
            return
        }
        
        let notes = notesTextView.text.isBlank() ? nil : notesTextView.text
        let registration = Registration(identifier: UUID().uuidString,
                                        carID: carID, clientID: userId,
                                        cost: nil,
                                        dateOfCreation: Date(),
                                        dateOfRegistration: resultDate,
                                        description: nil,
                                        notes: notes,
                                        status: .new,
                                        timeOfWorks: nil,
                                        typeOfWorks: type,
                                        serviceId: serviceId)
        
        registrationService.new(registration: registration)
        dismiss(animated: true, completion: nil)
    }
}
