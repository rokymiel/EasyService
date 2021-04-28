//
//  RegistrationService.swift
//  EasyService
//
//  Created by Михаил on 12.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import CoreData
import Firebase

protocol IRegistrationService {
    func getServices(completetion: @escaping (Result<[Service], Error>) -> Void)
    func getRegistration(with id: String, completetion: @escaping (Result<Registration, Error>) -> Void)
    func getRegistrations(with car: String, completetion: @escaping (Result<[Registration], Error>) -> Void)
    func add(delegate: UpdateDelegate)
    func new(registration: Registration)
    func count(user id: String, _ completetion: @escaping (Result<Int, Error>) -> Void)
    func getService(with id: String, completetion: @escaping (Result<Service, Error>) -> Void)
    func update(_ registration: Registration)
}

class RegistrationService: IRegistrationService {
    
    private var delegates = [WeakRef<UpdateDelegate>]()
    
    private let servicesFirestore: IFireStoreService
    private let regisrtationsFirestore: IFireStoreService
    private let coreDataManager: ICoreDataManager
    private let userID: String
    
    init(with userID: String, servicesFirestore: IFireStoreService, regisrtationsFirestore: IFireStoreService, coreDataManager: ICoreDataManager) {
        self.servicesFirestore = servicesFirestore
        self.regisrtationsFirestore = regisrtationsFirestore
        self.coreDataManager = coreDataManager
        self.userID = userID
        loadAndListent()
    }
    
    func getServices(completetion: @escaping (Result<[Service], Error>) -> Void) {
        servicesFirestore.loadDocuments(completetion)
    }
    
    func getService(with id: String, completetion: @escaping (Result<Service, Error>) -> Void) {
        servicesFirestore.loadDocument(id: id, completetion)
    }
    
    func getRegistration(with id: String, completetion: @escaping (Result<Registration, Error>) -> Void) {
        readFromCore(with: id, completetion)
    }
    func getRegistrations(with car: String, completetion : @escaping (Result<[Registration], Error>) -> Void) {
        readAllFromCore(with: car, completetion)
    }
    func add(delegate: UpdateDelegate) {
        delegates.append(.init(value: delegate))
    }
    
    private func readAllFromCore(with car: String, _ completetion: @escaping (Result<[Registration], Error>) -> Void) {
        let request: NSFetchRequest<RegistrationDB> = RegistrationDB.fetchRequest()
        let predicate = NSPredicate(format: "carID == %@", car)
        let salarySort = NSSortDescriptor(key: "dateOfRegistration", ascending: false)
        request.sortDescriptors = [salarySort]
        request.predicate = predicate
        coreDataManager.fetchAll(request: request) { registrations in
            if let registrations = registrations {
                print("COREregistrations", registrations)
                completetion(.success(registrations.map { $0.dataModel }))
            } else {
                completetion(.failure(NoneError.none))
            }
        }
    }
    private func readFromCore(with id: String, _ completetion: @escaping (Result<Registration, Error>) -> Void) {
        let request: NSFetchRequest<RegistrationDB> = RegistrationDB.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", id)
        request.predicate = predicate
        coreDataManager.fetch(request: request) { registration in
            if let registration = registration {
                completetion(.success(registration.dataModel))
            } else {
                completetion(.failure(NoneError.none))
            }
        }
    }
    
    private func loadAndListent() {
        regisrtationsFirestore.loadDocuments(where: Registration.CodingKeys.clientID.rawValue,
                                             isEqualTo: userID) { (result: Result<[(type: DocumentChangeType, item: Registration?)], Error>) in
            switch result {
            case .success(let registrations):
                let group = DispatchGroup()
                for (type, car) in registrations {
                    switch type {
                    case .added, .modified:
                        if let car = car {
                            group.enter()
                            self.coreDataManager.save(model: car) {
                                group.leave()
                            }
                        }
                    case .removed:
                        print("removed")
                    }
                }
                group.notify(queue: .global()) {
                    self.delegates.forEach { $0.value?.updated(self) }
                }
            case .failure(let error):
                self.delegates.forEach { $0.value?.faild(with: error, self) }
            }
        }
    }
    
    func new(registration: Registration) {
        if let id = registration.identifier {
            regisrtationsFirestore.addDocument(with: id, from: registration)
        }
    }
    
    func count(user id: String, _ completetion: @escaping (Result<Int, Error>) -> Void) {
        let request: NSFetchRequest<NSFetchRequestResult> = RegistrationDB.fetchRequest()
        let predicate = NSPredicate(format: "clientID == %@", id)
        request.predicate = predicate
        coreDataManager.count(request: request) { (num) in
            if let num = num {
                completetion(.success(num))
            } else {
                completetion(.failure(NoneError.none))
            }
        }
    }
    
    func update(_ registration: Registration) {
        if let id = registration.identifier {
            regisrtationsFirestore.addDocument(with: id, from: registration)
        }
    }
}
