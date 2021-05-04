//
//  AuthorizationDelegateStub.swift
//  EasyServiceTests
//
//  Created by Михаил on 01.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import Foundation

class AuthorizationDelegateStub: NSObject, AuthorizationDelegate {
    
    func authorizationDidChange(_ auth: Aauthorization) {}
}
