//
//  ServiceAssembly.swift
//  EasyService
//
//  Created by Михаил on 14.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Firebase

protocol IServiceAssembly {
    func buildRegisrtationService() -> IRegistrationService
    func buildAccountService() -> IAccountService
}

final class ServiceAssembly: IServiceAssembly {
    private lazy var db = Firestore.firestore()
    private lazy var servicesFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("services"))
    private lazy var registrationsFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("registrations"))
    private lazy var usersFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("users"))
//    private lazy var registrationsFirestoreService: IFireStoreService = FireStoreService(reference: db.collection("user"))
    private lazy var coreDataStack: ICoreDatsStack = CoreDataStack()
    private lazy var coreDataManager: ICoreDataManager = CoreDataManager(dataStack: coreDataStack)
    private lazy var authServiceFactory: IAuthServiceFactory = AuthServiceFactory()
    private lazy var accountService: IAccountService = AccountService(authServiceFactory: authServiceFactory,
                                                                      fireStoreService: usersFirestoreService,
                                                                      coreDataManager: coreDataManager)
    private lazy var registrationService: IRegistrationService = RegistrationService(servicesFirestore: servicesFirestoreService, regisrtationsFirestore: registrationsFirestoreService)
    
    func buildRegisrtationService() -> IRegistrationService {
        return registrationService
    }
    
    func buildAccountService() -> IAccountService {
        return accountService
    }
    
    
}