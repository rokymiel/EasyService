//
//  AccountService.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation
import CoreData
import Firebase

protocol IAccountService {
    func saveNew(user: User)
    func getUser(completition: @escaping (Result<User, Error>) -> Void)
    var currentId: String? { get }
    var delegate: AccountDelegate? { get set }
    func createUser(with email: String, password: String, _ completion: @escaping (Result<Firebase.User?, Error>) -> Void)
    
    func signIn(with email: String, password: String, completion: @escaping (Result<String?, Error>) -> Void)
    
    func signOut() throws
}

protocol AccountDelegate: NSObject {
    func login()
    func logout()
}

final class AccountService: NSObject, IAccountService {
    typealias UserCallback = (Result<User, Error>) -> Void
    private var callbacks = [UserCallback]()
    weak var delegate: AccountDelegate? {
        didSet {
            if authService.userId != nil {
                delegate?.login()
            } else {
                delegate?.logout()
            }
        }
    }
    private var id: String?
    private var listenerRegistration: ListenerRegistration?
    private let fireStoreService: IFireStoreService
    private let coreDataManager: ICoreDataManager
    private let authServiceFactory: IAuthServiceFactory
    private var authService: IAuthService!
    private var taskExecutor: ITaskExecutor
    
    init(authServiceFactory: IAuthServiceFactory, fireStoreService: IFireStoreService, coreDataManager: ICoreDataManager, taskExecutor: ITaskExecutor) {
        print("ACCINIT")
        self.fireStoreService = fireStoreService
        self.coreDataManager = coreDataManager
        self.authServiceFactory = authServiceFactory
        self.taskExecutor = taskExecutor
        self.taskExecutor.queue = .global()
        super.init()
        authService = self.authServiceFactory.buildAuthService(self)
    }
    
    func saveNew(user: User) {
        if let id = user.identifier {
            fireStoreService.addDocument(with: id, from: user)
        }
        coreDataManager.save(model: user, nil)
    }
    
    func getUser(completition: @escaping (Result<User, Error>) -> Void) {
        if let userId = authService.userId {
            getUser(with: userId, completition: completition)
        } else {
            completition(.failure(NoneError.none))
        }
    }
    
    var currentId: String? {
        authService.userId
    }
    
    func createUser(with email: String, password: String, _ completion: @escaping (Result<Firebase.User?, Error>) -> Void) {
        authService.createUser(with: email, password: password, completion)
    }
    
    func signIn(with email: String, password: String, completion: @escaping (Result<String?, Error>) -> Void) {
        authService.signIn(with: email, password: password, completion)
    }
    
    func signOut() throws {
        try authService.signOut()
    }
    
    // MARK: - Private
    
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
    
    private func loadUser(with id: String) {
        listenerRegistration = fireStoreService.loadDocument(id: id, listener: userLoaded)
    }
    
    private func userLoaded(result: (Result<User, Error>)) {
        print("ULOAD", result)
        if case let .success(user) = result {
            coreDataManager.save(model: user, nil)
        }
    }
}

extension AccountService: AuthorizationDelegate {
    func authorizationDidChange(_ auth: Aauthorization) {
        switch auth {
        case .user(let user):
            id = currentId
            loadUser(with: user.uid)
            delegate?.login()
            taskExecutor.async {
                self.authService.token { token, _ in
                    if let token = token {
                        self.fireStoreService.addDocument(of: user.uid, to: "tokens", with: token, from: Token(token: token))
                    }
                }
            }
        case .none:
            print("NONE")
            listenerRegistration?.remove()
            taskExecutor.async { [id] in
                self.authService.token { token, _ in
                    if let token = token, let userId = id {
                        print("REMOVE", token)
                        self.fireStoreService.removeDocument(of: userId, to: "tokens", with: token)
                    }
                }
            }
            id = nil
            coreDataManager.deleteAll(request: UserDB.fetchRequest())
            delegate?.logout()
        }
    }
}
