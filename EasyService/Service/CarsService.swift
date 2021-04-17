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
}

class CarsService: ICarsService {
    
    private let carsFirebaseService: IFireStoreService
    private let coreDataManager: ICoreDataManager
    
    init(carsFirebaseService: IFireStoreService, coreDataManager: ICoreDataManager) {
        self.carsFirebaseService = carsFirebaseService
        self.coreDataManager = coreDataManager
    }
    
    func saveNew(car: Car) {
        if let id = car.identifier {
            _ = carsFirebaseService.addDocument(with: id, from: car)
        }
        coreDataManager.save(model: car, nil)
    }
    
    func getCars(_ completetion: @escaping (Result<[Car], Error>) -> Void) {
        readFromCore(completetion)
        
        loadCompletition { (result) in
            switch result {
            case .failure(let error):
                completetion(.failure(error))
            case .success(let cars):
                print("LOAD",cars)
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
                    self.readFromCore(completetion)
                }
                
            }
            
        }
    }
    
    private func readFromCore(_ completetion: @escaping (Result<[Car], Error>) -> Void) {
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
    
    private func loadCompletition(_ completion: @escaping (Result<[(type: DocumentChangeType, item: Car?)], Error>) -> Void) {
        carsFirebaseService.loadDocuments(completion)
    }
    
}
