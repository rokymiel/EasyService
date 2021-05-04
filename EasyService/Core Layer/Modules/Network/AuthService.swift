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
    
    var userId: String? { get }
    
    func createUser(with email: String, password: String, _ completion: @escaping (Result<Firebase.User?, Error>) -> Void)
    
    func signIn(with email: String, password: String, _ completion: @escaping (Result<String?, Error>) -> Void)
    
    func signOut() throws
    
    func token(_ completion: @escaping (String?, Error?) -> Void)
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
    
    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    func createUser(with email: String, password: String, _ completion: @escaping (Result<Firebase.User?, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(authResult?.user))
        }
    }
    
    func signIn(with email: String, password: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(authResult?.user.uid))
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func token(_ completion: @escaping (String?, Error?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                completion(nil, error)
            } else if let token = token {
                completion(token, nil)
            }
        }
    }
}
