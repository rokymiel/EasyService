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
    func buildRegisrtationController(_ completition: @escaping () -> Void) -> RegistrationViewController
    func buildLoginController(_ completition: @escaping () -> Void) -> LoginViewController
    func buildCarListController() -> CarListViewController
    func buildItemInListChooserViewController() -> ItemInListChooserViewController
    func buildNewCarViewController(on saved: @escaping (Car) -> Void) -> NewCarViewController
    func buildServicesMapViewController() -> ServicesMapViewController
    func buildNewServiceRegisrtationViewController(with car: Car, service: Service) -> NewServiceRegisrtationViewController
    func buildServiceRegistrationViewController(with registrationId: String) -> ServiceRegistrationViewController
    func buildAnnotationDetailsViewController() -> AnnotationDetailsViewController
    func buildProfileViewController() -> ProfileViewController
    func buildHomeViewController() -> HomeViewController
    func buildNavigationController(root: UIViewController?) -> UINavigationController
    func buildCarMainController() -> CarMainViewController
}

final class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func buildRegisrtationController(_ completition: @escaping () -> Void) -> RegistrationViewController {
        return RegistrationViewController.sInit(accountService: serviceAssembly.getAccountService(), completition)
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
        return NewCarViewController.sInit(resourcesService: serviceAssembly.getResourcesService(), presentationAssembly: self, on: saved)
    }
    
    func buildServicesMapViewController() -> ServicesMapViewController {
        return ServicesMapViewController.sInit(presentationAssembly: self, registrationService: serviceAssembly.getRegisrtationService())
    }
    
    func buildNewServiceRegisrtationViewController(with car: Car, service: Service) -> NewServiceRegisrtationViewController {
        if let userId = serviceAssembly.getAccountService().currentId {
            return NewServiceRegisrtationViewController.sInit(userId: userId,
                                                              service: service,
                                                              car: car,
                                                              registrationService: serviceAssembly.getRegisrtationService(),
                                                              presentationAssembly: self)
        }
        fatalError("Должен быть получен пользователь")
    }
    
    func buildServiceRegistrationViewController(with registrationId: String) -> ServiceRegistrationViewController {
        return ServiceRegistrationViewController.sInit(with: registrationId, registrationService: serviceAssembly.getRegisrtationService())
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
        return HomeViewController.sInit(registrationService: serviceAssembly.getRegisrtationService(), carsService: serviceAssembly.getCarsService(), presentationAssembly: self)
    }
    
    func buildNavigationController(root: UIViewController? = nil) -> UINavigationController {
        let nv: UINavigationController
        if let root = root {
            nv = UINavigationController(rootViewController: root)
        } else {
            nv = UINavigationController()
        }
        return nv
    }
    
    func buildCarMainController() -> CarMainViewController {
        return CarMainViewController(presentationAssembly: self, carsService: serviceAssembly.getCarsService())
    }
}
