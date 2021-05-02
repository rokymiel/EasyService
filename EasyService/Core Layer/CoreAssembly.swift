//
//  CoreAssembly.swift
//  EasyService
//
//  Created by Михаил on 27.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Firebase

protocol ICoreAssembly {
    func getLocalDictionary() -> ILocalDictionary
    func getCoreDataStack() -> ICoreDatsStack
    func getFireStoreService(with reference: CollectionReference) -> IFireStoreService
    func getAuthService(_ delegate: AuthorizationDelegate) -> IAuthService
    func getResources() -> IResources
    func assembleTaskExecutor() -> ITaskExecutor
}

class CoreAssembly: ICoreAssembly {
    private lazy var localDictionary = LocalDictionary()
    private lazy var coreDataStack = CoreDataStack()
    private lazy var resources = Resources()
    
    func getLocalDictionary() -> ILocalDictionary {
        return localDictionary
    }
    
    func getCoreDataStack() -> ICoreDatsStack {
        return coreDataStack
    }
    
    func getFireStoreService(with reference: CollectionReference) -> IFireStoreService {
        return FireStoreService(reference: reference)
    }
    
    func getAuthService(_ delegate: AuthorizationDelegate) -> IAuthService {
        return AuthService(delegate)
    }
    
    func getResources() -> IResources {
        return resources
    }
    
    
    func assembleTaskExecutor() -> ITaskExecutor {
        return TaskExecutor()
    }
}
