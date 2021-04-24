//
//  AuthService.swift
//  EasyService
//
//  Created by Михаил on 16.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Firebase

enum Aauthorization {
    case user(FirebaseAuth.User)
    case none
}

protocol AuthorizationDelegate: NSObject {
    func authorizationDidChange(_ auth: Aauthorization)
}

protocol IAuthService {
    var delegate: AuthorizationDelegate? { get set }
    
    var user: Firebase.User? { get }
    
    func createUser(with email: String, password: String, _ completion: @escaping (Result<Firebase.User, Error>) -> Void)
    
    func signIn(with email: String, password: String, _ completion: @escaping (Result<Firebase.User, Error>) -> Void)
    
    func signOut() throws
}

class AuthService: IAuthService {
    
    public weak var delegate: AuthorizationDelegate?
    
    init(_ delegate: AuthorizationDelegate) {
        self.delegate = delegate
        Auth.auth().addStateDidChangeListener { (_, user) in
            if let user = user {
                self.delegate?.authorizationDidChange(.user(user))
            } else {
                self.delegate?.authorizationDidChange(.none)
            }
        }
    }
    
    var user: Firebase.User? {
        Auth.auth().currentUser
    }
    
    func createUser(with email: String, password: String,_ completion: @escaping (Result<Firebase.User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error != nil else {
                completion(.failure(error ?? NoneError.none))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func signIn(with email: String, password: String, _ completion: @escaping (Result<Firebase.User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error != nil else {
                completion(.failure(error ?? NoneError.none))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
