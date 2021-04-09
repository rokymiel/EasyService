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
    func buildCarListController() -> CarListViewController
    func buildItemInListChooserViewController() -> ItemInListChooserViewController
    func buildNewCarViewController() -> NewCarViewController
}

final class PresentationAssembly: IPresentationAssembly {
    private lazy var db = Firestore.firestore()
    private lazy var firestoreService: IFireStoreService = FireStoreService(reference: db.collection("users"))
    private lazy var accountService: IAccountService = AccountService(fireStoreService: firestoreService)
    
    func buildRegisrtationController() -> RegisrtationViewController {
        return RegisrtationViewController.sInit(accountService: accountService)
    }
    
    func buildLoginController() -> LoginViewController {
        return LoginViewController.sInit(accountService: accountService, presentationAssembly: self)
    }
    
    func buildCarListController() -> CarListViewController {
        return CarListViewController.sInit(accountService: accountService, presentationAssembly: self)
    }
    
    func buildItemInListChooserViewController() -> ItemInListChooserViewController {
        return ItemInListChooserViewController.sInit()
    }
    
    func buildNewCarViewController() -> NewCarViewController {
        return NewCarViewController.sInit(presentationAssembly: self)
    }
}
