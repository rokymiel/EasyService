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
    func buildAuthService(_ delegate: AuthorizationDelegate) -> IAuthService {
        return AuthService(delegate)
    }
}
