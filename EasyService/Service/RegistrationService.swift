//
//  RegistrationService.swift
//  EasyService
//
//  Created by Михаил on 12.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

protocol IRegistrationService {
    func getServices(compilation: @escaping (Result<[Service], Error>) -> Void)
}

class RegistrationService: IRegistrationService {
    
    private let fireStoreService: IFireStoreService
    
    init(fireStoreService: IFireStoreService) {
        self.fireStoreService = fireStoreService
    }
    
    func getServices(compilation: @escaping (Result<[Service], Error>) -> Void) {
        fireStoreService.loadDocuments(compilation)
    }
}
