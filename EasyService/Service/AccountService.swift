//
//  AccountService.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation
import CoreData

protocol IAccountService {
    func saveNew(user: User)
    func getUser(completition: @escaping (Result<User, Error>) -> Void)
}

final class AccountService: NSObject, IAccountService, AuthorizationDelegate {
    
    func authorizationDidChange(_ auth: Aauthorization) {
        switch auth {
        case .user(let user):
            self.getUser(with: user.uid) { (result) in
                if case let .success(user) = result   {
                    self.coreDataManager.save(model: user, nil)
                }
            }
        case .none:
            print("NONE")
            // delete
        }
    }
    
    
    private let fireStoreService: IFireStoreService
    private let coreDataManager: ICoreDataManager
    private let authServiceFactory: IAuthServiceFactory
    private var authService: IAuthService!
    
    init(authServiceFactory: IAuthServiceFactory, fireStoreService: IFireStoreService, coreDataManager: ICoreDataManager) {
        self.fireStoreService = fireStoreService
        self.coreDataManager = coreDataManager
        self.authServiceFactory = authServiceFactory
        super.init()
        authService = self.authServiceFactory.buildAuthService(self)
    }
    
    func saveNew(user: User) {
        _ = fireStoreService.addDocument(from: user)
        coreDataManager.save(model: user, nil)
    }
    
    
    func getUser(completition: @escaping (Result<User, Error>) -> Void) {
        if let user = authService.user {
            getUser(with: user.uid, completition: completition)
        } else {
            completition(.failure(NoneError.none))
        }
    }
    
    private func getUser(with id: String, completition: @escaping (Result<User, Error>) -> Void) {
        let request: NSFetchRequest<UserDB> = UserDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", id)
        request.predicate = predicate
        coreDataManager.fetch(request: request) { (result) in
            if let user = result {
                completition(.success(user.user))
            } else {
                completition(.failure(NoneError.none))
            }
        }
        fireStoreService.loadDocument(id: id, listener: completition)
    }
}

enum NoneError: Error {
    case none
}
