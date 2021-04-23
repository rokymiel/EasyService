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
    func buildRegisrtationController(_ completition: @escaping () -> Void) -> RegisrtationViewController
    func buildLoginController(_ completition: @escaping () -> Void) -> LoginViewController
    func buildCarListController() -> CarListViewController
    func buildItemInListChooserViewController() -> ItemInListChooserViewController
    func buildNewCarViewController(on saved: @escaping (Car) -> Void) -> NewCarViewController
    func buildServicesMapViewController() -> ServicesMapViewController
    func buildNewServiceRegisrtationViewController(with car: Car, service: Service) -> NewServiceRegisrtationViewController
    func buildAnnotationDetailsViewController() -> AnnotationDetailsViewController
    func buildProfileViewController() -> ProfileViewController
    func buildHomeViewController() -> HomeViewController
}

final class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServiceAssembly
        
    private lazy var db = Firestore.firestore()
    private lazy var usersFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("users"))
    private lazy var servicesFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("services"))
    private lazy var registrationsFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("registrations"))
    
    private lazy var resourcesService: IResourcesService = ResourcesService()
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func buildRegisrtationController(_ completition: @escaping () -> Void) -> RegisrtationViewController {
        return RegisrtationViewController.sInit(accountService: serviceAssembly.getAccountService(), completition)
    }
    
    func buildLoginController(_ completition: @escaping () -> Void) -> LoginViewController {
        return LoginViewController.sInit(accountService: serviceAssembly.getAccountService(), presentationAssembly: self, completition)
    }
    
    func buildCarListController() -> CarListViewController {
        return CarListViewController.sInit(carsService: serviceAssembly.getCarsService(), presentationAssembly: self)
    }
    
    func buildItemInListChooserViewController() -> ItemInListChooserViewController {
        return ItemInListChooserViewController.sInit()
    }
    
    func buildNewCarViewController(on saved: @escaping (Car) -> Void) -> NewCarViewController {
        return NewCarViewController.sInit(resourcesService: resourcesService, presentationAssembly: self, on: saved)
    }
    func buildServicesMapViewController() -> ServicesMapViewController {
        return ServicesMapViewController.sInit(presentationAssembly: self, registrationService: serviceAssembly.getRegisrtationService())
    }
    
    func buildNewServiceRegisrtationViewController(with car: Car, service: Service) -> NewServiceRegisrtationViewController {
        if let userId = serviceAssembly.getAccountService().currentId {
            return NewServiceRegisrtationViewController.sInit(userId: userId, service: service, car: car, registrationService: serviceAssembly.getRegisrtationService(), presentationAssembly: self)
        }
        fatalError("Должен быть получен пользователь")
    }
    
    func buildAnnotationDetailsViewController() -> AnnotationDetailsViewController {
        return AnnotationDetailsViewController(carsService: serviceAssembly.getCarsService(), presentationAssembly: self)
    }
    
    func buildProfileViewController() -> ProfileViewController {
        return ProfileViewController.sInit(accountService: serviceAssembly.getAccountService(),
                                           carsService: serviceAssembly.getCarsService(),
                                           registrationService: serviceAssembly.getRegisrtationService())
    }
    
    func buildHomeViewController() -> HomeViewController {
        return HomeViewController.sInit(registrationService: serviceAssembly.getRegisrtationService(), carsService: serviceAssembly.getCarsService())
    }
}
