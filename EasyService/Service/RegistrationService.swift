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
    func getRegistrations(compilation: @escaping (Result<[Registration], Error>) -> Void)
    func new(registration: Registration)
}

class RegistrationService: IRegistrationService {
    
    private let servicesFirestore: IFireStoreService
    private let regisrtationsFirestore: IFireStoreService
    
    init(servicesFirestore: IFireStoreService, regisrtationsFirestore: IFireStoreService) {
        self.servicesFirestore = servicesFirestore
        self.regisrtationsFirestore = regisrtationsFirestore
    }
    
    func getServices(compilation: @escaping (Result<[Service], Error>) -> Void) {
        servicesFirestore.loadDocuments(compilation)
    }
    
    func getRegistrations(compilation: @escaping (Result<[Registration], Error>) -> Void) {
        regisrtationsFirestore.loadDocuments(compilation)
    }
    
    func new(registration: Registration) {
        if let id = registration.identifier {
            regisrtationsFirestore.addDocument(with: id, from: registration)
        }
    }
}
