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
}

class CarsService: ICarsService {
    
    private let carsFirebaseService: IFireStoreService
    private let coreDataManager: ICoreDataManager
    private let localDictionary: ILocalDictionary
    
    init(carsFirebaseService: IFireStoreService, coreDataManager: ICoreDataManager, localDictionary: ILocalDictionary) {
        self.carsFirebaseService = carsFirebaseService
        self.coreDataManager = coreDataManager
        self.localDictionary = localDictionary
        self.currentId = localDictionary.get("selected_car_id") as? String
    }
    
    func saveNew(car: Car) {
        if let id = car.identifier {
            _ = carsFirebaseService.addDocument(with: id, from: car)
        }
        coreDataManager.save(model: car, nil)
    }
    
    var currentId: String?
    
    func select(id: String) {
        // save to
        currentId = id
        localDictionary.set(id, for: "selected_car_id")
    }
    
    func deselect() {
        localDictionary.remove("selected_car_id")
        currentId = nil
    }
    
    func getCar(_ completetion: @escaping (Result<Car, Error>) -> Void) {
        readCurrentFromCore(completetion)
        // TODO: - добавить получение по сети
    }
     
    func getCars(_ completetion: @escaping (Result<[Car], Error>) -> Void) {
        readAllFromCore(completetion)
        
        loadCompletition { (result) in
            switch result {
            case .failure(let error):
                completetion(.failure(error))
            case .success(let cars):
                print("LOAD", cars)
                completetion(.success(cars.compactMap { $0.item }))
                let group = DispatchGroup()
                for (type, car) in cars {
                    switch type {
                    case .added, .modified:
                        if let car = car {
                            group.enter()
                            self.coreDataManager.save(model: car) {                                 group.leave()
                            }
                        }
                    case .removed:
                        print("removed")
                    }
                }
                group.notify(queue: .global()) {
                    self.readAllFromCore(completetion)
                }
                
            }
            
        }
    }
    
    private func readAllFromCore(_ completetion: @escaping (Result<[Car], Error>) -> Void) {
        let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()
        coreDataManager.fetchAll(request: request) { (cars) in
            if let cars = cars {
                print("CORE",cars)
                completetion(.success(cars.map { $0.dataModel }))
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
                    print("CORE",car)
                    completetion(.success(car.dataModel))
                } else {
                    completetion(.failure(NoneError.none))
                }
            }
        }
    }
    
    private func loadCompletition(_ completion: @escaping (Result<[(type: DocumentChangeType, item: Car?)], Error>) -> Void) {
        carsFirebaseService.loadDocuments(completion)
    }
    
}
