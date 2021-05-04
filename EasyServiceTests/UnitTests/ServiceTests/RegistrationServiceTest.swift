//
//  RegistrationServiceTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import  XCTest
import Firebase

class RegistrationServiceTest: XCTestCase {
    var userID: String!
    var servicesFirestoreMock: FireStoreServiceMock!
    var regisrtationsFirestoreMock: FireStoreServiceMock!
    var coreDataManagerMock: CoreDataManagerMock!
    var registrationService: RegistrationService!
    
    override func setUp() {
        super.setUp()
        userID = "QWERTY"
        servicesFirestoreMock = FireStoreServiceMock()
        regisrtationsFirestoreMock = FireStoreServiceMock()
        regisrtationsFirestoreMock.stubbedLoadDocumentsWhereStringIsEqualToAnyResulttypeDocumentChangeTypeitemTErrorVoidResult = ListenerRegistrationStub()
        coreDataManagerMock = CoreDataManagerMock()
        registrationService = RegistrationService(with: userID,
                                                  servicesFirestore: servicesFirestoreMock,
                                                  regisrtationsFirestore: regisrtationsFirestoreMock,
                                                  coreDataManager: coreDataManagerMock)
    }
    
    override func tearDown() {
        super.tearDown()
        userID = nil
        servicesFirestoreMock = nil
        regisrtationsFirestoreMock = nil
        coreDataManagerMock = nil
        registrationService = nil
    }
    
    func test_getService() {
        // given
        let serviceID = "SERVICE_ID"
        
        // when
        registrationService.getService(with: serviceID) { _ in }
        
        // then
        XCTAssertTrue(servicesFirestoreMock.invokedLoadDocumentIdString)
        XCTAssertEqual(serviceID, servicesFirestoreMock.invokedLoadDocumentIdStringParameters?.id)
    }
    
    func test_getServices() {
        // when
        registrationService.getServices { _ in }
        
        // then
        XCTAssertTrue(servicesFirestoreMock.invokedLoadDocumentsResultTErrorVoid)
    }
    
    func test_getRegistration() {
        // given
        let id = "REGISTRATION_ID"
        let context = CoreDataStackMock().storeContainer.viewContext
        let registration = Registration.fake(identifier: id)
        let registrationDB = RegistrationDB(registration: registration, in: context)
        coreDataManagerMock.stubbedFetchBlockResult = (registrationDB, ())
        
        // when
        var res: Registration?
        registrationService.getRegistration(with: id) { result in
            switch result {
            case .success(let reg):
                res = reg
            case .failure:
                assertionFailure()
            }
        }
        
        // then
        XCTAssertTrue(coreDataManagerMock.invokedFetch)
        XCTAssertNotNil(res)
        XCTAssertEqual(res?.identifier, id)
    }
    
    func test_getRegistrations() {
        // given
        let id = "REGISTRATION_ID"
        let context = CoreDataStackMock().storeContainer.viewContext
        let registration = Registration.fake(identifier: id)
        let registrationDB = RegistrationDB(registration: registration, in: context)
        coreDataManagerMock.stubbedFetchAllBlockResult = ([registrationDB], ())
        
        // when
        var res: [Registration]?
        registrationService.getRegistrations(with: "CAR_ID") { result in
            switch result {
            case .success(let reg):
                res = reg
            case .failure:
                assertionFailure()
            }
        }
        
        // then
        XCTAssertTrue(coreDataManagerMock.invokedFetchAll)
        XCTAssertNotNil(res)
        XCTAssertEqual(res?.count, 1)
        XCTAssertEqual(res?.first?.identifier, id)
    }
    
    func test_add() {
        // given
        let delegate1 = UpdateDelegateStub()
        let delegate2 = UpdateDelegateStub()

        // when
        registrationService.add(delegate: delegate1)
        registrationService.add(delegate: delegate2)

        // then
        XCTAssertEqual(registrationService.delegates.count, 2)
    }
    
    func test_delegatesWeak() {
        // given
        let delegate1 = UpdateDelegateStub()
        
        // when
        registrationService.add(delegate: delegate1)
        do {
            let delegate2 = UpdateDelegateStub()
            registrationService.add(delegate: delegate2)
        }
        
        // then
        XCTAssertEqual(registrationService.delegates.count, 2)
        XCTAssertNil(registrationService.delegates.last?.value)
    }
    
    func test_new() {
        // given
        let registration: Registration = .fake(identifier: "REGISTRATION_ID")
        
        // when
        registrationService.new(registration: registration)
        
        // then
        XCTAssertTrue(regisrtationsFirestoreMock.invokedAddDocumentWith)
        XCTAssertEqual(registration.identifier, regisrtationsFirestoreMock.invokedAddDocumentWithParameters?.id)
        XCTAssertEqual(registration.identifier, (regisrtationsFirestoreMock.invokedAddDocumentWithParameters?.value as? Registration)?.identifier)
    }
    
    func test_count() {
        // given
        coreDataManagerMock.stubbedCountBlockResult = (5, ())

        var res = 0
        // when
        registrationService.count(user: userID) { result in
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
    
    func test_update() {
        // given
        let registration: Registration = .fake(identifier: "REGISTRATION_ID")
        
        // when
        registrationService.update(registration)
        
        // then
        XCTAssertTrue(regisrtationsFirestoreMock.invokedAddDocumentWith)
        XCTAssertEqual(registration.identifier, regisrtationsFirestoreMock.invokedAddDocumentWithParameters?.id)
        XCTAssertEqual(registration.identifier, (regisrtationsFirestoreMock.invokedAddDocumentWithParameters?.value as? Registration)?.identifier)
    }
    
    func test_deleteRegistrations() {
        // when
        registrationService.deleteRegistrations()
        
        // then
        XCTAssertTrue(coreDataManagerMock.invokedDeleteAll)
    }
    
}
