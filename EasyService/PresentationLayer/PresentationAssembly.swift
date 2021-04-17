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
    func buildRegisrtationController(_ completition: @escaping (String) -> Void) -> RegisrtationViewController
    func buildLoginController(_ completition: @escaping (String) -> Void) -> LoginViewController
    func buildCarListController(with userId: String) -> CarListViewController
    func buildItemInListChooserViewController() -> ItemInListChooserViewController
    func buildNewCarViewController(on saved: @escaping (Car) -> Void) -> NewCarViewController
    func buildServicesMapViewController() -> ServicesMapViewController
}

final class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServiceAssembly
    
    
    private lazy var db = Firestore.firestore()
    private lazy var usersFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("users"))
    private lazy var servicesFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("services"))
    private lazy var registrationsFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("registrations"))
   

    private lazy var resourcesService: IResourcesService = ResourcesService()
    private lazy var registrationService: IRegistrationService = RegistrationService(servicesFirestore: servicesFirestoreService, regisrtationsFirestore: registrationsFirestoreService)
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func buildRegisrtationController(_ completition: @escaping (String) -> Void) -> RegisrtationViewController {
        return RegisrtationViewController.sInit(accountService: serviceAssembly.getAccountService(), completition)
    }
    
    func buildLoginController(_ completition: @escaping (String) -> Void) -> LoginViewController {
        return LoginViewController.sInit(accountService: serviceAssembly.getAccountService(), presentationAssembly: self, completition)
    }
    
    func buildCarListController(with userId: String) -> CarListViewController {
        return CarListViewController.sInit(carsService: serviceAssembly.getCarService(with: userId), presentationAssembly: self)
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
