//
//  AuthServiceFactoryMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService

class AuthServiceFactoryMock: IAuthServiceFactory {
    
    var invokedBuildAuthService = false
    var invokedBuildAuthServiceCount = 0
    var invokedBuildAuthServiceParameters: (delegate: AuthorizationDelegate, Void)?
    var invokedBuildAuthServiceParametersList = [(delegate: AuthorizationDelegate, Void)]()
    var stubbedBuildAuthServiceResult: IAuthService!
    
    func buildAuthService(_ delegate: AuthorizationDelegate) -> IAuthService {
        invokedBuildAuthService = true
        invokedBuildAuthServiceCount += 1
        invokedBuildAuthServiceParameters = (delegate, ())
        invokedBuildAuthServiceParametersList.append((delegate, ()))
        return stubbedBuildAuthServiceResult
    }
}
