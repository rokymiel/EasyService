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
    
    private var presentationAssembly: PresentationAssembly!
    private var resourcesService: IResourcesService!
    class func sInit(resourcesService: IResourcesService, presentationAssembly: PresentationAssembly) -> NewCarViewController {
        let contraller = UIStoryboard.newCarViewController.instantiate(self)
        contraller.presentationAssembly = presentationAssembly
        contraller.resourcesService = resourcesService
        //        contraller.accountService = accountService
        return contraller
    }
    let yearPicker = UIPickerView()
    var yearPickerDelegate: UIYearPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        yearPicker.selectRow(year-1890, inComponent: 0, animated: false)
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        yearTextField.inputAccessoryView = toolbar
        yearTextField.inputView = yearPicker
        
        
        chooser = presentationAssembly.buildItemInListChooserViewController()
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
    
    var chooser: ItemInListChooserViewController?
    private var cars: [String: [String]]?
    private var gears: [String]?
    private var carsBodies: [String]?
    
    @IBAction func markClicked(_ sender: Any) {
        
        if let controller = chooser {
            controller.items = cars?.keys.sorted()
            controller.itemChosenHandler = { str in
                self.markTextField.text = str
            }
            present(controller, animated: true)
        }
    }
    
    @IBAction func modelClicked(_ sender: Any) {
        if let controller = chooser {
            controller.items = cars?[markTextField.text ?? ""]
            controller.itemChosenHandler = { str in
                self.modelTextField.text = str
            }
            present(controller, animated: true)
        }
    }
    
    @IBAction func bodyClicked(_ sender: Any) {
        if let controller = chooser {
            controller.items = carsBodies
            controller.itemChosenHandler = { str in
                self.bodyTextField.text = str
            }
            present(controller, animated: true)
        }
    }
    
    @IBAction func gearClicked(_ sender: Any) {
        if let controller = chooser {
            controller.items = gears
            
            controller.itemChosenHandler = { str in
                self.gearTextField.text = str
            }
            present(controller, animated: true)
        }
    }
    
    private var lastVolumeTextField: Double = 0.2
    
    @IBAction func engineVolumeChanged(_ sender: Any) {
        if let text = engineVolumeTextField.text, !text.isBlank() {
            if let num = Double(text), num >= 0, num <= 10 {
                lastVolumeTextField = num
                engineVolumeStepper.value = floor(num*10)
                return
            }
            engineVolumeTextField.text = String(lastVolumeTextField)
            return
        }
        lastVolumeTextField = 0.2
        engineVolumeStepper.value = 2
        
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        
        engineVolumeTextField.text = String( engineVolumeStepper.value/10)
    }
}

extension NewCarViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
