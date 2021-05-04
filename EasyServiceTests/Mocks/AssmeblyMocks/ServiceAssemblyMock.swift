//
//  ServiceAssemblyMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 29.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService

class ServiceAssemblyMock: IServiceAssembly {
    
    var invokedGetRegisrtationService = false
    var invokedGetRegisrtationServiceCount = 0
    var stubbedGetRegisrtationServiceResult: IRegistrationService!
    
    func getRegisrtationService() -> IRegistrationService {
        invokedGetRegisrtationService = true
        invokedGetRegisrtationServiceCount += 1
        return stubbedGetRegisrtationServiceResult
    }
    
    var invokedGetAccountService = false
    var invokedGetAccountServiceCount = 0
    var stubbedGetAccountServiceResult: IAccountService!
    
    func getAccountService() -> IAccountService {
        invokedGetAccountService = true
        invokedGetAccountServiceCount += 1
        return stubbedGetAccountServiceResult
    }
    
    var invokedGetCarsService = false
    var invokedGetCarsServiceCount = 0
    var stubbedGetCarsServiceResult: ICarsService!
    
    func getCarsService() -> ICarsService {
        invokedGetCarsService = true
        invokedGetCarsServiceCount += 1
        return stubbedGetCarsServiceResult
    }
    
    var invokedGetResourcesService = false
    var invokedGetResourcesServiceCount = 0
    var stubbedGetResourcesServiceResult: IResourcesService!
    
    func getResourcesService() -> IResourcesService {
        invokedGetResourcesService = true
        invokedGetResourcesServiceCount += 1
        return stubbedGetResourcesServiceResult
    }
}
