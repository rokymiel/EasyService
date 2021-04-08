//
//  PresentationAssembly.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

final class PresentationAssembly {
    lazy var accountService: IAccountService = AccountService()
    
    func buildRegisrtationController() -> RegisrtationViewController {
        return RegisrtationViewController.sInit(accountService: accountService)
    }
    
    func buildLoginController() -> LoginViewController {
        return LoginViewController.sInit()
    }
}
