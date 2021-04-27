//
//  ServiceAssembly.swift
//  EasyService
//
//  Created by Михаил on 14.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Firebase

protocol IServiceAssembly {
    func getRegisrtationService() -> IRegistrationService
    func getAccountService() -> IAccountService
    func getCarsService() -> ICarsService
    func getResourcesService() -> IResourcesService
}

final class ServiceAssembly: IServiceAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    private lazy var resourcesService: IResourcesService = ResourcesService(resources: coreAssembly.getResources())
    private lazy var db = Firestore.firestore()
    private lazy var servicesFirestoreService: IFireStoreService = coreAssembly.getFireStoreService(with: db.collection("services"))
    private lazy var registrationsFirestoreService: IFireStoreService = coreAssembly.getFireStoreService(with: db.collection("registrations"))
    private lazy var usersFirestoreService: IFireStoreService = coreAssembly.getFireStoreService(with: db.collection("users"))
    private var userId: String?
    private lazy var carsFirestoreService: IFireStoreService = coreAssembly.getFireStoreService(with: db.collection("users"))
    //    private lazy var registrationsFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("user"))
    private lazy var localDictionary: ILocalDictionary = coreAssembly.getLocalDictionary()
    private lazy var coreDataStack: ICoreDatsStack = coreAssembly.getCoreDataStack()
    private lazy var coreDataManager: ICoreDataManager = CoreDataManager(dataStack: coreDataStack)
    private lazy var authServiceFactory: IAuthServiceFactory = AuthServiceFactory(coreAssembly: coreAssembly)
    private lazy var accountService: IAccountService = AccountService(authServiceFactory: authServiceFactory,
                                                                      fireStoreService: usersFirestoreService,
                                                                      coreDataManager: coreDataManager)
    private var carsService: ICarsService!
    private var registrationService: IRegistrationService!
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    func getResourcesService() -> IResourcesService {
        return resourcesService
    }
    
    func getRegisrtationService() -> IRegistrationService {
        if let userId = userId {
            if userId != accountService.currentId {
                update()
            }
            return registrationService
            
        }
        userId = accountService.currentId
        update()
        return registrationService
    }
    
    func getAccountService() -> IAccountService {
        return accountService
    }
    
    func getCarsService() -> ICarsService {
        if let userId = userId {
            if userId != accountService.currentId {
                update()
            }
            return carsService
            
        }
        userId = accountService.currentId
        update()
        return carsService
        
    }
    
    private func update() {
        registrationService = RegistrationService(with: userId!, servicesFirestore: servicesFirestoreService, regisrtationsFirestore: registrationsFirestoreService, coreDataManager: coreDataManager)
        carsService = CarsService(carsFirebaseService: FireStoreService(reference: db.collection("users").document(userId!).collection("cars")),
                                  coreDataManager: coreDataManager, localDictionary: localDictionary)
    }
        
}
