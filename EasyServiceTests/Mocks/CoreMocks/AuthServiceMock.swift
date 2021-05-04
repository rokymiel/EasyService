//
//  AuthServiceMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 29.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import Firebase

class AuthServiceMock: IAuthService {
    
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: AuthorizationDelegate?
    var invokedDelegateList = [AuthorizationDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: AuthorizationDelegate!
    
    var delegate: AuthorizationDelegate? {
        get {
            invokedDelegateGetter = true
            invokedDelegateGetterCount += 1
            return stubbedDelegate
        }
        set {
            invokedDelegateSetter = true
            invokedDelegateSetterCount += 1
            invokedDelegate = newValue
            invokedDelegateList.append(newValue)
        }
    }
    
    var invokedUserIdGetter = false
    var invokedUserIdGetterCount = 0
    var stubbedUserId: String!
    
    var userId: String? {
        invokedUserIdGetter = true
        invokedUserIdGetterCount += 1
        return stubbedUserId
    }
    
    var invokedCreateUser = false
    var invokedCreateUserCount = 0
    var invokedCreateUserParameters: (email: String, password: String)?
    var invokedCreateUserParametersList = [(email: String, password: String)]()
    var stubbedCreateUserCompletionResult: (Result<Firebase.User?, Error>, Void)?
    
    func createUser(with email: String, password: String, _ completion: @escaping (Result<Firebase.User?, Error>) -> Void) {
        invokedCreateUser = true
        invokedCreateUserCount += 1
        invokedCreateUserParameters = (email, password)
        invokedCreateUserParametersList.append((email, password))
        if let result = stubbedCreateUserCompletionResult {
            completion(result.0)
        }
    }
    
    var invokedSignIn = false
    var invokedSignInCount = 0
    var invokedSignInParameters: (email: String, password: String)?
    var invokedSignInParametersList = [(email: String, password: String)]()
    var stubbedSignInCompletionResult: (Result<String?, Error>, Void)?
    
    func signIn(with email: String, password: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
        invokedSignIn = true
        invokedSignInCount += 1
        invokedSignInParameters = (email, password)
        invokedSignInParametersList.append((email, password))
        if let result = stubbedSignInCompletionResult {
            completion(result.0)
        }
    }
    
    var invokedSignOut = false
    var invokedSignOutCount = 0
    var stubbedSignOutError: Error?
    
    func signOut() throws {
        invokedSignOut = true
        invokedSignOutCount += 1
        if let error = stubbedSignOutError {
            throw error
        }
    }
    
    var invokedToken = false
    var invokedTokenCount = 0
    var stubbedTokenCompletionResult: (String?, Error?)?
    
    func token(_ completion: @escaping (String?, Error?) -> Void) {
        invokedToken = true
        invokedTokenCount += 1
        if let result = stubbedTokenCompletionResult {
            completion(result.0, result.1)
        }
    }
}
