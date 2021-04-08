//
//  RegisrtationViewController.swift
//  EasyService
//
//  Created by Михаил on 06.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import FirebaseAuth

final class RegisrtationViewController: UIBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var accountService: IAccountService!
    
    let datePicker = UIDatePicker()
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        return f
    }()
    
    class func sInit(accountService: IAccountService) -> RegisrtationViewController {
        let contraller = UIStoryboard.regisrtation.instantiate(RegisrtationViewController.self)
        contraller.accountService = accountService
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
    }
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
    }
    
    @objc func donedatePicker() {
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func emailEditingDidEnd(_ sender: Any) {
        if let email = emailTextField.text, !email.isEmail() {
            emailTextField.textColor = UIColor.red
            emailLabel.textColor = UIColor.red
        }
    }
    
    @IBAction func phoneEditingDidEnd(_ sender: Any) {
        if let phone = phoneTextField.text, !phone.isRUPhone() {
            phoneTextField.textColor = UIColor.red
            phoneLabel.textColor = UIColor.red
        }
    }
    
    @IBAction func phoneEditingDidBegin(_ sender: Any) {
        phoneTextField.textColor = nil
        phoneLabel.textColor = nil
    }
    
    @IBAction func emailEditingDidBegin(_ sender: Any) {
        emailTextField.textColor = nil
        emailLabel.textColor = nil
    }
    
    @IBAction func surnameEditingDidEnd(_ sender: Any) {
        guard let text = surnameTextField.text, !text.isBlank() else {
            surnameLabel.textColor = UIColor.red
            return
        }
        
    }
    @IBAction func surnameEditingDidBegin(_ sender: Any) {
        surnameLabel.textColor = nil
    }
    
    @IBAction func nameEditingDidEnd(_ sender: Any) {
        guard let text = nameTextField.text, !text.isBlank() else {
            nameLabel.textColor = UIColor.red
            return
        }
        
    }
    @IBAction func nameEditingDidBegin(_ sender: Any) {
        nameLabel.textColor = nil
    }
    @IBAction func dateEditingDidBegin(_ sender: Any) {
        dateLabel.textColor = nil
        dateTextField.textColor = nil
    }
    
    @IBAction func dateEditingDidEnd(_ sender: Any) {
        
        guard let date = dateTextField.text, formatter.isDate(string: date) else {
            dateLabel.textColor = UIColor.red
            dateTextField.textColor = UIColor.red
            return
        }
    }
    
    @IBAction func createAccountClicked(_ sender: Any) {
        self.view.endEditing(true)
        guard let name = nameTextField.text,
            let surname = surnameTextField.text,
            let dateStr = dateTextField.text,
            let email = emailTextField.text,
            let phone = phoneTextField.text,
            !name.isBlank(),
            !surname.isBlank(),
            let date = formatter.date(from: dateStr),
            email.isEmail(),
            phone.isRUPhone() else { return; }
        let patronymic = patronymicTextField.text
        guard passwordTextField.text != nil, repeatPasswordTextField.text != nil else {
            showAlert(with: "Введите пароль!")
            return
        }
        guard passwordTextField.text == repeatPasswordTextField.text else {
            showAlert(with: "Пароли не совпадают!")
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: passwordTextField.text!) { authResult, error in
//            print("Hi")
//            print(error)
            if let error = error {
                self.showAlert(with: error.localizedDescription)
                return
            }
//            print("AuthRes: ", authResult)
//            print("Info: ", authResult?.additionalUserInfo)
            if let fUser = authResult?.user {
                let user = User(identifier: fUser.uid,
                                name: name,
                                surname: surname,
                                patronymic: patronymic,
                                dateOfBirth: date,
                                phone: phone,
                                email: email,
                                carIDs: nil,
                                registrationsIDs: nil)
                self.accountService.saveNew(user: user)
                
            }
        }
    }
}