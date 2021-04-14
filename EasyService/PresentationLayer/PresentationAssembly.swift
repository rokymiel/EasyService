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
    func buildNewCarViewController(on saved: @escaping (Car) -> Void) -> NewCarViewController
    func buildServicesMapViewController() -> ServicesMapViewController
}

final class PresentationAssembly: IPresentationAssembly {
    private lazy var db = Firestore.firestore()
    private lazy var usersFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("users"))
    private lazy var servicesFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("services"))
    private lazy var registrationsFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("registrations"))
    private lazy var accountService: IAccountService = AccountService(fireStoreService: usersFirestoreService)
    private lazy var resourcesService: IResourcesService = ResourcesService()
    private lazy var registrationService: IRegistrationService = RegistrationService(servicesFirestore: servicesFirestoreService, regisrtationsFirestore: registrationsFirestoreService)
    
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
    
    func buildNewCarViewController(on saved: @escaping (Car) -> Void) -> NewCarViewController {
        return NewCarViewController.sInit(resourcesService: resourcesService, presentationAssembly: self, on: saved)
    }
    func buildServicesMapViewController() -> ServicesMapViewController {
        return ServicesMapViewController.sInit(registrationService: registrationService)
    }
}
