//
//  LoginViewController.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import Firebase

final class LoginViewController: UIViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UIRoundedTextField!
    
    @IBOutlet weak var passwordTextField: UIRoundedTextField!
    
    private var presentationAssembly: IPresentationAssembly!
    private var accountService: IAccountService!
    private var completition: (() -> Void)!
    
    class func sInit(accountService: IAccountService, presentationAssembly: IPresentationAssembly, _ completition: @escaping () -> Void) -> LoginViewController {
        let contraller = UIStoryboard.login.instantiate(LoginViewController.self)
        contraller.presentationAssembly = presentationAssembly
        contraller.completition = completition
        contraller.accountService = accountService
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isBlank(), email.isEmail() else {
            showAlert(with: "Введите почту!")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(with: "Введите пароль!")
            return
        }
        accountService.signIn(with: email, password: password) { result in
            switch result {
            case .success:
                self.dismiss(animated: true, completion: self.completition)
            case .failure(let error):
                self.showAlert(with: error.localizedDescription)
            }
        }
    }
    
    @IBAction func showRegisrtationView(_ sender: Any) {
        let regisrtationController = presentationAssembly.buildRegisrtationController {
            self.dismiss(animated: true, completion: self.completition)
        }
        present(presentationAssembly.buildNavigationController(root: regisrtationController), animated: true)
    }
}
