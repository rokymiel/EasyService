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
    var currentId: String? { get }
    var delegate: AccountDelegate? { get set }
}

protocol AccountDelegate: NSObject {
    func login()
    func logout()
}

final class AccountService: NSObject, IAccountService, AuthorizationDelegate {
    typealias UserCallback = (Result<User, Error>) -> Void
    private var callbacks = [UserCallback]()
    weak var delegate: AccountDelegate? {
        didSet {
            if authService.user != nil {
                delegate?.login()
            } else {
                delegate?.logout()
            }
        }
    }
    
    func authorizationDidChange(_ auth: Aauthorization) {
        switch auth {
        case .user(let user):
            currentId = user.uid
            loadUser(with: user.uid)
            delegate?.login()
        case .none:
            print("NONE")
            // TODO: - clear cash
            currentId = nil
            delegate?.logout()
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
        if let id = user.identifier {
            _ = fireStoreService.addDocument(with: id, from: user)
        }
        coreDataManager.save(model: user, nil)
    }
    
    func getUser(completition: @escaping (Result<User, Error>) -> Void) {
        if let user = authService.user {
            print(user.uid)
            getUser(with: user.uid, completition: completition)
        } else {
            completition(.failure(NoneError.none))
        }
    }
    
    var currentId: String?
    
    private func getUser(with id: String, completition: @escaping (Result<User, Error>) -> Void) {
        let request: NSFetchRequest<UserDB> = UserDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", id)
        request.predicate = predicate
        coreDataManager.fetch(request: request) { (result) in

            if let dbUser = result {
                let user = dbUser.dataModel
                completition(.success(user))
            } else {
                completition(.failure(NoneError.none))
            }
        }
    }
    
    func loadUser(with id: String) {
        fireStoreService.loadDocument(id: id, listener: userLoaded)
    }
    
    func userLoaded(result: (Result<User, Error>)) {
        if case let .success(user) = result {
            coreDataManager.save(model: user, nil)
        }
    }
}

enum NoneError: Error {
    case none
}
