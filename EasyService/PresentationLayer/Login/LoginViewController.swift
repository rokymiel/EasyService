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
    private var completition: ((String) -> Void)!
    
    class func sInit(accountService: IAccountService, presentationAssembly: IPresentationAssembly, _ completition: @escaping (String) -> Void) -> LoginViewController {
        let contraller = UIStoryboard.login.instantiate(LoginViewController.self)
        contraller.presentationAssembly = presentationAssembly
        contraller.completition = completition
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        loginView.layer.cornerRadius = 20
        loginView.layer.shadowColor = UIColor.black.cgColor
        loginView.layer.shadowOpacity = 0.3
        loginView.layer.shadowOffset = .zero
        loginView.layer.shadowRadius = 20
        loginView.layer.shadowPath = UIBezierPath(rect: loginView.bounds).cgPath
        loginView.layer.shouldRasterize = true
        loginView.layer.rasterizationScale = UIScreen.main.scale
        
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
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showAlert(with: error.localizedDescription)
                return
            }
            if let user = result?.user {
                self.dismiss(animated: true, completion: { self.completition(user.uid) } )

            }
        }
    }
    
    @IBAction func showRegisrtationView(_ sender: Any) {
        present(presentationAssembly.buildRegisrtationController { id in
            self.dismiss(animated: true, completion: { self.completition(id) } )
        }, animated: true)
    }
}
