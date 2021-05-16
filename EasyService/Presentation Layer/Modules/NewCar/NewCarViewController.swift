//
//  NewCarViewController.swift
//  EasyService
//
//  Created by Михаил on 02.01.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class NewCarViewController: UITableViewController {
    
    @IBOutlet weak var markTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var gearTextField: UITextField!
    @IBOutlet weak var engineVolumeTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var engineVolumeStepper: UIStepper!
    @IBOutlet weak var mileageTextField: UITextField!
    
    private var presentationAssembly: IPresentationAssembly!
    private var resourcesService: IResourcesService!
    private var saved: ((Car) -> Void)!
    class func sInit(resourcesService: IResourcesService, presentationAssembly: IPresentationAssembly, on saved: @escaping (Car) -> Void) -> NewCarViewController {
        let contraller = UIStoryboard.newCarViewController.instantiate(self)
        contraller.presentationAssembly = presentationAssembly
        contraller.resourcesService = resourcesService
        contraller.saved = saved
        return contraller
    }
    
    let yearPicker = UIPickerView()
    var yearPickerDelegate: UIYearPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новый автомобиль"
        navigationController?.navigationBar.barTintColor = tableView.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        addCloseItem()
        hideKeyboardWhenTappedAround()
        markTextField.delegate = self
        modelTextField.delegate = self
        bodyTextField.delegate = self
        gearTextField.delegate = self
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        yearPickerDelegate = UIYearPickerDelegate(min: 1890, max: year)
        yearPicker.dataSource = yearPickerDelegate
        yearPicker.delegate = yearPickerDelegate
        yearPicker.selectRow(year - 1890, inComponent: 0, animated: false)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        yearTextField.inputAccessoryView = toolbar
        yearTextField.inputView = yearPicker
        
        cars = resourcesService.getCars()
        gears = resourcesService.getGears()
        carsBodies = resourcesService.getCarsBodies()
    }
    
    @objc func donedatePicker() {
        yearTextField.text = String(yearPicker.selectedRow(inComponent: 0) + 1890)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    private var cars: [String: [String]]?
    private var gears: [String]?
    private var carsBodies: [String]?
    
    @IBAction func markClicked(_ sender: Any) {
        let controller = presentationAssembly.buildItemInListChooserViewController()
        controller.items = cars?.keys.sorted()
        controller.itemChosenHandler = { str in
            self.markTextField.text = str
        }
        present(controller, animated: true)
    }
    
    @IBAction func modelClicked(_ sender: Any) {
        let controller = presentationAssembly.buildItemInListChooserViewController()
        controller.items = cars?[markTextField.text ?? ""]
        controller.itemChosenHandler = { str in
            self.modelTextField.text = str
        }
        present(controller, animated: true)
        
    }
    
    @IBAction func bodyClicked(_ sender: Any) {
        let controller = presentationAssembly.buildItemInListChooserViewController()
        controller.items = carsBodies
        controller.itemChosenHandler = { str in
            self.bodyTextField.text = str
        }
        present(controller, animated: true)
    }
    
    @IBAction func gearClicked(_ sender: Any) {
        let controller = presentationAssembly.buildItemInListChooserViewController()
        controller.items = gears
        
        controller.itemChosenHandler = { str in
            self.gearTextField.text = str
        }
        present(controller, animated: true)
    }
    
    private var lastVolumeTextField: Double = 0.2
    
    @IBAction func engineVolumeChanged(_ sender: Any) {
        if let text = engineVolumeTextField.text, !text.isBlank() {
            if let num = Double(text), num >= 0, num <= 10 {
                lastVolumeTextField = num
                engineVolumeStepper.value = floor(num * 10)
                return
            }
            engineVolumeTextField.text = String(lastVolumeTextField)
            return
        }
        lastVolumeTextField = 0.2
        engineVolumeStepper.value = 2
        
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        engineVolumeTextField.text = String( engineVolumeStepper.value / 10)
    }
    
    @IBAction func carSavedClicked(_ sender: Any) {
        guard let mark = markTextField.text,
              let model = modelTextField.text,
              let body = bodyTextField.text,
              let gear = gearTextField.text,
              let engineStr = engineVolumeTextField.text,
              let engine = Double(engineStr),
              let yearStr = yearTextField.text,
              let year = Int(yearStr),
              let mileageStr = mileageTextField.text,
              let mileage = Int(mileageStr) else {
            markTextField.setPlaceholder(color: .systemRed)
            modelTextField.setPlaceholder(color: .systemRed)
            bodyTextField.setPlaceholder(color: .systemRed)
            gearTextField.setPlaceholder(color: .systemRed)
            engineVolumeTextField.setPlaceholder(color: .systemRed)
            yearTextField.setPlaceholder(color: .systemRed)
            mileageTextField.setPlaceholder(color: .systemRed)
            return
        }
        
        saved(Car(identifier: UUID().uuidString, mark: mark, model: model,
                  body: body, gear: gear, engine: engine, productionYear: year,
                  mileage: [.init(date: Date(), value: mileage, isVerified: false)]))
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension NewCarViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
