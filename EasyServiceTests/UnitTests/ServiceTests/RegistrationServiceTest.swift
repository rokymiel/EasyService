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
    
    func test_getServices() {
        // given
        
        // when
        
        // then
    }
    
    func test_getRegistration() {
        // given
        
        // when
        
        // then
    }
    
    func test_getRegistrations() {
        // given
        
        // when
        
        // then
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
        
        // when
        
        // then
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
    
    func test_getService() {
        // given
        
        // when
        
        // then
    }
    
    func test_update() {
        // given
        
        // when
        
        // then
    }
    
    func test_deleteRegistrations() {
        // when
        registrationService.deleteRegistrations()
        
        // then
        XCTAssertTrue(coreDataManagerMock.invokedDeleteAll)
    }
    
}
