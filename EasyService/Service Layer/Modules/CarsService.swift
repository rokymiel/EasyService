//
//  CarsService.swift
//  EasyService
//
//  Created by Михаил on 17.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import CoreData
import Firebase

protocol ICarsService {
    func getCars(_ completetion: @escaping (Result<[Car], Error>) -> Void)
    func saveNew(car: Car)
    var currentId: String? { get }
    func select(id: String)
    func deselect()
    func getCar(_ completetion: @escaping (Result<Car, Error>) -> Void)
    func count(_ completetion: @escaping (Result<Int, Error>) -> Void)
    func add(delegate: UpdateDelegate)
    var delegates: [WeakRef<UpdateDelegate>] { get }
    func addMileage(_ mileage: Mileage, failure handler: ((Error) -> Void)?)
    func deleteCars()
}

extension ICarsService {
    func addMileage(_ mileage: Mileage, failure handler: ((Error) -> Void)? = nil) {
        addMileage(mileage, failure: handler)
    }
}

class CarsService: ICarsService {
    private(set) var delegates = [WeakRef<UpdateDelegate>]()
    
    private let carsFirebaseService: IFireStoreService
    private let coreDataManager: ICoreDataManager
    private let localDictionary: ILocalDictionary
    
    init(carsFirebaseService: IFireStoreService, coreDataManager: ICoreDataManager, localDictionary: ILocalDictionary) {
        self.carsFirebaseService = carsFirebaseService
        self.coreDataManager = coreDataManager
        self.localDictionary = localDictionary
        self.currentId = localDictionary.get("selected_car_id") as? String
        loadAndListen()
    }
    
    func add(delegate: UpdateDelegate) {
        delegates.append(.init(value: delegate))
    }
    
    func saveNew(car: Car) {
        if let id = car.identifier {
            carsFirebaseService.addDocument(with: id, from: car)
        }
        coreDataManager.save(model: car, nil)
    }
    
    var currentId: String?
    
    func addMileage(_ mileage: Mileage, failure handler: ((Error) -> Void)? = nil) {
        getCar { result in
            switch result {
            case .failure(let error):
                handler?(error)
            case .success(var car):
                print("MIIIILLLL", car.mileage)
                car.mileage.append(mileage)
                if let carId = car.identifier {
                    self.carsFirebaseService.addDocument(with: carId, from: car)
                }
            }
        }
    }
    
    func select(id: String) {
        currentId = id
        localDictionary.set(id, for: "selected_car_id")
    }
    
    func deselect() {
        localDictionary.remove("selected_car_id")
        currentId = nil
    }
    
    func getCar(_ completetion: @escaping (Result<Car, Error>) -> Void) {
        readCurrentFromCore(completetion)
    }
     
    func getCars(_ completetion: @escaping (Result<[Car], Error>) -> Void) {
        readAllFromCore(completetion)
    }
    
    func deleteCars() {
        listenerRegistration?.remove()
        coreDataManager.deleteAll(request: CarDB.fetchRequest())
    }
    
    private func loadAndListen() {
        loadCompletition { (result) in
            switch result {
            case .failure(let error):
                self.delegates.forEach { $0.value?.faild(with: error, self) }
            case .success(let cars):
                print("LOAD", cars)
                let group = DispatchGroup()
                for (type, car) in cars {
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
                
            }
            
        }
    }
    
    private func readAllFromCore(_ completetion: @escaping (Result<[Car], Error>) -> Void) {
        let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()
        coreDataManager.fetchAll(request: request) { (cars) in
            if let cars = cars {
                print("CORE", cars)
                completetion(.success(cars.map { $0.dataModel }))
            } else {
                completetion(.failure(NoneError.none))
            }
        }
    }
    
    func count(_ completetion: @escaping (Result<Int, Error>) -> Void) {
        let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()
        coreDataManager.count(request: request) { (num) in
            if let num = num {
                completetion(.success(num))
            } else {
                completetion(.failure(NoneError.none))
            }
        }
    }
    
    private func readCurrentFromCore(_ completetion: @escaping (Result<Car, Error>) -> Void) {
        if let id = currentId {
            let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()
            let predicate = NSPredicate(format: "identifier == %@", id)
            request.predicate = predicate
            coreDataManager.fetch(request: request) { (car) in
                if let car = car {
                    print("CORE", car)
                    completetion(.success(car.dataModel))
                } else {
                    completetion(.failure(NoneError.none))
                }
            }
        }
    }
    private var listenerRegistration: ListenerRegistration?
    private func loadCompletition(_ completion: @escaping (Result<[(type: DocumentChangeType, item: Car?)], Error>) -> Void) {
        listenerRegistration = carsFirebaseService.loadDocuments(completion)
    }
    
}
