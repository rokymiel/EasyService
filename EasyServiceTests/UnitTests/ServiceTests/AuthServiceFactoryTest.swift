//
//  AuthServiceFactoryTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 01.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import XCTest

class AuthServiceFactoryTest: XCTestCase {
    var authServiceFactory: IAuthServiceFactory!
    var coreAssemblyMock: CoreAssemblyMock!
    var authorizationDelegateStub: AuthorizationDelegateStub!
    
    override func setUp() {
        super.setUp()
        authorizationDelegateStub = AuthorizationDelegateStub()
        coreAssemblyMock = CoreAssemblyMock()
        authServiceFactory = AuthServiceFactory(coreAssembly: coreAssemblyMock)
    }
    
    override func tearDown() {
        super.tearDown()
        authorizationDelegateStub = nil
        coreAssemblyMock = nil
        authServiceFactory = nil
    }
    
    func test_buildAuthService() {
        // given
        coreAssemblyMock.stubbedGetAuthServiceResult = AuthServiceMock()

        // when
        let res = authServiceFactory.buildAuthService(authorizationDelegateStub)
        
        // then
        assert(res as? AuthServiceMock === coreAssemblyMock.stubbedGetAuthServiceResult as? AuthServiceMock)
        XCTAssertTrue(coreAssemblyMock.invokedGetAuthService)
        XCTAssertEqual(authorizationDelegateStub, coreAssemblyMock.invokedGetAuthServiceParameters?.delegate)
    }
}
