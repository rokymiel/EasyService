//
//  AuthServiceFactory.swift
//  EasyService
//
//  Created by Михаил on 16.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

protocol IAuthServiceFactory {
    func buildAuthService(_ delegate: AuthorizationDelegate) -> IAuthService
}

class AuthServiceFactory: IAuthServiceFactory {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    func buildAuthService(_ delegate: AuthorizationDelegate) -> IAuthService {
        return coreAssembly.getAuthService(delegate)
    }
}
