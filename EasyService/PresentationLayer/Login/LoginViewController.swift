//
//  LoginViewController.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

final class LoginViewController: UIBaseViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UIRoundedTextField!
    
    @IBOutlet weak var passwordTextField: UIRoundedTextField!
    
    class func sInit() -> LoginViewController {
        let contraller = UIStoryboard.login.instantiate(LoginViewController.self)
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    
    @IBAction func showRegisrtationView(_ sender: Any) {
        if let regisrtationController = UIStoryboard.regisrtation.instantiateInitialViewController() as? RegisrtationViewController {
             present(regisrtationController, animated: true)
        }
    }
}
