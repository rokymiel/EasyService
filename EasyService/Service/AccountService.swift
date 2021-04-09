//
//  AccountService.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

protocol IAccountService {
    func saveNew(user: User)
}

final class AccountService: IAccountService {
    
    private let fireStoreService: IFireStoreService
    
    init(fireStoreService: IFireStoreService) {
        self.fireStoreService = fireStoreService
    }
    
    func saveNew(user: User) {
        _ = fireStoreService.addDocument(from: user)
    }  
}
