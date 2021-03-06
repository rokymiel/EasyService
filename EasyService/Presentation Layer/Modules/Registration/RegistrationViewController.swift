//
//  RegistrationViewController.swift
//  EasyService
//
//  Created by Михаил on 06.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

final class RegistrationViewController: UITableViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var createAccountButton: UIRoundedButton!
    
    private var accountService: IAccountService!
    private var completition: (() -> Void)!
    
    let datePicker = UIDatePicker()
    
    class func sInit(accountService: IAccountService, _ completition: @escaping () -> Void) -> RegistrationViewController {
        let contraller = UIStoryboard.registration.instantiate(self)
        contraller.accountService = accountService
        contraller.completition = completition
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        navigationController?.navigationBar.barTintColor = tableView.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        addCloseItem()
        showDatePicker()
        hideKeyboardWhenTappedAround()
    }
    
    func showDatePicker() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.locale = .preferredLocale
        datePicker.sizeToFit()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        if #available(iOS 14.0, *) {
            dateTextField.inputView?.frame = CGRect(x: 0, y: 0, width: dateTextField.inputView?.frame.width ?? 0, height: 400)
        }
    }
    
    @objc func donedatePicker() {
        dateTextField.text = datePicker.date.fullDate
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
        phoneTextField.textColor = .label
        phoneLabel.textColor = .label
    }
    
    @IBAction func emailEditingDidBegin(_ sender: Any) {
        emailTextField.textColor = .label
        emailLabel.textColor = .label
    }
    
    @IBAction func surnameEditingDidEnd(_ sender: Any) {
        guard let text = surnameTextField.text, !text.isBlank() else {
            surnameLabel.textColor = UIColor.red
            return
        }
        
    }
    
    @IBAction func surnameEditingDidBegin(_ sender: Any) {
        surnameLabel.textColor = .label
    }
    
    @IBAction func nameEditingDidEnd(_ sender: Any) {
        guard let text = nameTextField.text, !text.isBlank() else {
            nameLabel.textColor = UIColor.red
            return
        }
        
    }
    
    @IBAction func nameEditingDidBegin(_ sender: Any) {
        nameLabel.textColor = .label
    }
    
    @IBAction func dateEditingDidBegin(_ sender: Any) {
        dateLabel.textColor = .label
        dateTextField.textColor = .label
    }
    
    @IBAction func dateEditingDidEnd(_ sender: Any) {
        
        guard let date = dateTextField.text, DateFormatter.fullDateFormatter().isDate(string: date) else {
            dateLabel.textColor = UIColor.red
            dateTextField.textColor = UIColor.red
            return
        }
    }
    
    @IBAction func createAccountClicked(_ sender: Any) {
        createAccountButton.isEnabled = false
        self.view.endEditing(true)
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let dateStr = dateTextField.text,
              let email = emailTextField.text,
              let phone = phoneTextField.text,
              !name.isBlank(),
              !surname.isBlank(),
              let date = DateFormatter.fullDateFormatter().date(from: dateStr),
              email.isEmail(),
              phone.isRUPhone() else {
            createAccountButton.isEnabled = true
            return
        }
        
        let patronymic = patronymicTextField.text
        guard passwordTextField.text != nil, repeatPasswordTextField.text != nil else {
            showAlert(with: "Введите пароль!")
            createAccountButton.isEnabled = true
            return
        }
        
        guard passwordTextField.text == repeatPasswordTextField.text else {
            showAlert(with: "Пароли не совпадают!")
            createAccountButton.isEnabled = true
            return
        }
        
        accountService.createUser(with: email, password: passwordTextField.text!) { result in
            switch result {
            case .success(let fUser):
                if let fUser = fUser {
                    let user = User(identifier: fUser.uid,
                                    name: name,
                                    surname: surname,
                                    patronymic: patronymic,
                                    dateOfBirth: date,
                                    phone: phone,
                                    email: email)
                    self.accountService.saveNew(user: user)
                    self.dismiss(animated: true, completion: self.completition)
                }
            case .failure(let error):
                self.showAlert(with: error.localizedDescription)
                self.createAccountButton.isEnabled = true
            }
        }
        
    }
}
