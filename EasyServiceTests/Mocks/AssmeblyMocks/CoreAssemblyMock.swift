//
//  CoreAssemblyMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 29.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import  Firebase

class CoreAssemblyMock: ICoreAssembly {

    var invokedGetLocalDictionary = false
    var invokedGetLocalDictionaryCount = 0
    var stubbedGetLocalDictionaryResult: ILocalDictionary!

    func getLocalDictionary() -> ILocalDictionary {
        invokedGetLocalDictionary = true
        invokedGetLocalDictionaryCount += 1
        return stubbedGetLocalDictionaryResult
    }

    var invokedGetCoreDataStack = false
    var invokedGetCoreDataStackCount = 0
    var stubbedGetCoreDataStackResult: ICoreDatsStack!

    func getCoreDataStack() -> ICoreDatsStack {
        invokedGetCoreDataStack = true
        invokedGetCoreDataStackCount += 1
        return stubbedGetCoreDataStackResult
    }

    var invokedGetFireStoreService = false
    var invokedGetFireStoreServiceCount = 0
    var invokedGetFireStoreServiceParameters: (reference: CollectionReference, Void)?
    var invokedGetFireStoreServiceParametersList = [(reference: CollectionReference, Void)]()
    var stubbedGetFireStoreServiceResult: IFireStoreService!

    func getFireStoreService(with reference: CollectionReference) -> IFireStoreService {
        invokedGetFireStoreService = true
        invokedGetFireStoreServiceCount += 1
        invokedGetFireStoreServiceParameters = (reference, ())
        invokedGetFireStoreServiceParametersList.append((reference, ()))
        return stubbedGetFireStoreServiceResult
    }

    var invokedGetAuthService = false
    var invokedGetAuthServiceCount = 0
    var invokedGetAuthServiceParameters: (delegate: AuthorizationDelegate, Void)?
    var invokedGetAuthServiceParametersList = [(delegate: AuthorizationDelegate, Void)]()
    var stubbedGetAuthServiceResult: IAuthService!

    func getAuthService(_ delegate: AuthorizationDelegate) -> IAuthService {
        invokedGetAuthService = true
        invokedGetAuthServiceCount += 1
        invokedGetAuthServiceParameters = (delegate, ())
        invokedGetAuthServiceParametersList.append((delegate, ()))
        return stubbedGetAuthServiceResult
    }

    var invokedGetResources = false
    var invokedGetResourcesCount = 0
    var stubbedGetResourcesResult: IResources!

    func getResources() -> IResources {
        invokedGetResources = true
        invokedGetResourcesCount += 1
        return stubbedGetResourcesResult
    }

    var invokedAssembleTaskExecutor = false
    var invokedAssembleTaskExecutorCount = 0
    var stubbedAssembleTaskExecutorResult: ITaskExecutor!

    func assembleTaskExecutor() -> ITaskExecutor {
        invokedAssembleTaskExecutor = true
        invokedAssembleTaskExecutorCount += 1
        return stubbedAssembleTaskExecutorResult
    }
}
