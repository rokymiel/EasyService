//
//  CarsService.swift
//  EasyService
//
//  Created by Михаил on 17.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import CoreData
 
protocol ICarsService {
    func getCars(_ completetion: @escaping (Result<[Car], Error>) -> Void)
}

class CarsService: ICarsService {
    
    private let carsFirebaseService: IFireStoreService
    private let coreDataManager: ICoreDataManager
    
    init(carsFirebaseService: IFireStoreService, coreDataManager: ICoreDataManager) {
        self.carsFirebaseService = carsFirebaseService
        self.coreDataManager = coreDataManager
    }
    
    func getCars(_ completetion: @escaping (Result<[Car], Error>) -> Void) {
        let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()
        coreDataManager.fetchAll(request: request) { (cars) in
            if let cars = cars {
                print(cars)
//                completetion(.success(cars))
            } else {
                completetion(.failure(NoneError.none))
            }
        }
    }
    
}
