//
//  CarsServiceTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import  XCTest
import Firebase

class CarsServiceTest: XCTestCase {
    var carsFirebaseServiceMock: FireStoreServiceMock!
    var coreDataManagerMock: CoreDataManagerMock!
    var localDictionaryMock: LocalDictionaryMock!
    var carsService: CarsService!
    
    override func setUp() {
        super.setUp()
        carsFirebaseServiceMock = FireStoreServiceMock()
        carsFirebaseServiceMock.stubbedLoadDocumentsResulttypeDocumentChangeTypeitemTErrorVoidResult = ListenerRegistrationStub()
        coreDataManagerMock = CoreDataManagerMock()
        localDictionaryMock = LocalDictionaryMock()
        carsService = CarsService(carsFirebaseService: carsFirebaseServiceMock, coreDataManager: coreDataManagerMock, localDictionary: localDictionaryMock)
    }
    
    override func tearDown() {
        super.tearDown()
        carsFirebaseServiceMock = nil
        coreDataManagerMock = nil
        localDictionaryMock = nil
        carsService = nil
    }
    
    func test_getCars() {
        // given
        let carId = "CAR_ID"
        let context = CoreDataStackMock().storeContainer.viewContext
        let car: Car = .fake(identifier: carId)
        let carsDB = [CarDB(car: car, in: context)]
        coreDataManagerMock.stubbedFetchAllBlockResult = (carsDB, ())
        
        // when
        var res: [Car]?
        carsService.getCars { result in
            switch result {
            case .success(let cars):
                res = cars
            case .failure:
                assertionFailure()
            }
        }
        // then
        XCTAssertTrue(coreDataManagerMock.invokedFetchAll)
        XCTAssertNotNil(res)
        XCTAssertEqual(res?.count, 1)
        XCTAssertEqual(res?.first?.identifier, carId)
    }
    
    func test_saveNew() {
        // given
        let car = Car.fake(identifier: "ID")
        
        // when
        carsService.saveNew(car: car)
        
        // then
        XCTAssertTrue(carsFirebaseServiceMock.invokedAddDocumentWith)
        XCTAssertEqual(carsFirebaseServiceMock.invokedAddDocumentWithParameters?.id, car.identifier)
        XCTAssertEqual((carsFirebaseServiceMock.invokedAddDocumentWithParameters?.value as? Car)?.identifier, car.identifier)
        XCTAssertTrue(coreDataManagerMock.invokedSave)
        XCTAssertEqual((coreDataManagerMock.invokedSaveParameters?.model as? Car)?.identifier, car.identifier)
    }
    
    func test_select() {
        // given
        let id = "ID"
        
        // when
        carsService.select(id: id)
        
        // then
        XCTAssertEqual(carsService.currentId, id)
        XCTAssertTrue(localDictionaryMock.invokedSet)
        XCTAssertEqual(localDictionaryMock.invokedSetParameters?.value as? String, id)
    }
    
    func test_deselect() {
        // when
        carsService.deselect()
        
        // then
        XCTAssertTrue(localDictionaryMock.invokedRemove)
        XCTAssertNil(carsService.currentId)
    }
    
    func test_getCar() {
        // given
        let carId = "CAR_ID"
        let context = CoreDataStackMock().storeContainer.viewContext
        let car: Car = .fake(identifier: carId)
        let carDB = CarDB(car: car, in: context)
        localDictionaryMock.stubbedGetResult = carId
        coreDataManagerMock.stubbedFetchBlockResult = (carDB, ())
        let carsService = CarsService(carsFirebaseService: carsFirebaseServiceMock, coreDataManager: coreDataManagerMock, localDictionary: localDictionaryMock)
        
        // when
        var res: Car?
        carsService.getCar { result in
            switch result {
            case .success(let car):
                res = car
            case .failure:
                assertionFailure()
            }
        }
        // then
        XCTAssertTrue(coreDataManagerMock.invokedFetch)
        XCTAssertNotNil(res)
        XCTAssertEqual(res?.identifier, carId)
        
    }
    
    func test_count() {
        // given
        coreDataManagerMock.stubbedCountBlockResult = (5, ())
        
        var res = 0
        // when
        carsService.count { result in
            switch result {
            case .success(let num):
                res = num
            case .failure:
                assertionFailure()
            }
        }
        
        // then
        XCTAssertTrue(coreDataManagerMock.invokedCount)
        XCTAssertEqual(res, 5)
    }
    
    func test_add() {
        // given
        let delegate1 = UpdateDelegateStub()
        let delegate2 = UpdateDelegateStub()
        
        // when
        carsService.add(delegate: delegate1)
        carsService.add(delegate: delegate2)
        
        // then
        XCTAssertEqual(carsService.delegates.count, 2)
    }
    
    func test_delegatesWeak() {
        // given
        let delegate1 = UpdateDelegateStub()
        
        // when
        carsService.add(delegate: delegate1)
        do {
            let delegate2 = UpdateDelegateStub()
            carsService.add(delegate: delegate2)
        }
        
        // then
        XCTAssertEqual(carsService.delegates.count, 2)
        XCTAssertNil(carsService.delegates.last?.value)
    }
    
    func test_addMileage() {
        // given
        
        // when
        
        // then
    }
    
    func test_deleteCars() {
        // when
        carsService.deleteCars()
        
        // then
        XCTAssertTrue(localDictionaryMock.invokedRemove)
        XCTAssertNil(carsService.currentId)
        XCTAssertTrue(coreDataManagerMock.invokedDeleteAll)
    }
}
