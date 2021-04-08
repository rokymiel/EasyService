//
//  PresentationAssembly.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import Firebase

protocol IPresentationAssembly {
    func buildRegisrtationController() -> RegisrtationViewController
    func buildLoginController() -> LoginViewController
}

final class PresentationAssembly: IPresentationAssembly {
    private lazy var db = Firestore.firestore()
    private lazy var firestoreService: IFireStoreService = FireStoreService(reference: db.collection("users"))
    private lazy var accountService: IAccountService = AccountService(fireStoreService: firestoreService)
    
    func buildRegisrtationController() -> RegisrtationViewController {
        return RegisrtationViewController.sInit(accountService: accountService)
    }
    
    func buildLoginController() -> LoginViewController {
        return LoginViewController.sInit(presentationAssembly: self)
    }
}
