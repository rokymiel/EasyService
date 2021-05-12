//
//  AccountServiceTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import XCTest
import Firebase
// swiftlint:disable force_cast

class AccountServiceTest: XCTestCase {
    var authServiceMock: AuthServiceMock!
    var authServiceFactoryMock: AuthServiceFactoryMock!
    var fireStoreServiceMock: FireStoreServiceMock!
    var taskExecutorMock: TaskExecutorMock!
    var coreDataManagerMock: CoreDataManagerMock!
    var accountService: IAccountService!
    
    override func setUp() {
        super.setUp()
        authServiceMock = AuthServiceMock()
        authServiceFactoryMock = AuthServiceFactoryMock()
        authServiceFactoryMock.stubbedBuildAuthServiceResult = authServiceMock
        fireStoreServiceMock = FireStoreServiceMock()
        coreDataManagerMock = CoreDataManagerMock()
        taskExecutorMock = TaskExecutorMock()
        taskExecutorMock.shouldInvokeAsyncWork = true
        accountService = AccountService(authServiceFactory: authServiceFactoryMock,
                                        fireStoreService: fireStoreServiceMock,
                                        coreDataManager: coreDataManagerMock,
                                        taskExecutor: taskExecutorMock)
    }
    
    override func tearDown() {
        super.tearDown()
        authServiceMock = nil
        authServiceFactoryMock = nil
        fireStoreServiceMock = nil
        coreDataManagerMock = nil
        taskExecutorMock = nil
        accountService = nil
    }
    
    func test_saveNew() {
        // given
        let user = User.fake(identifier: "ID")
        
        // when
        accountService.saveNew(user: user)
        
        // then
        XCTAssertTrue(fireStoreServiceMock.invokedAddDocumentWith)
        XCTAssertEqual(fireStoreServiceMock.invokedAddDocumentWithParameters?.id, user.identifier)
        XCTAssertEqual((fireStoreServiceMock.invokedAddDocumentWithParameters?.value as? EasyService.User)?.identifier, user.identifier)
        
        XCTAssertFalse(coreDataManagerMock.invokedSave)
    }
    
    func test_currentId() {
        // given
        authServiceMock.stubbedUserId = "ID"
        
        // when
        let res = accountService.currentId
        
        // then
        XCTAssertTrue(authServiceMock.invokedUserIdGetter)
        XCTAssertEqual(authServiceMock.stubbedUserId, res)
    }
    
    func test_getUserWithCurrentUserId() {
        // given
        let context = CoreDataStackMock().storeContainer.viewContext
        authServiceMock.stubbedUserId = "ID"
        let user = User.fake(identifier: "ID")
        let userDB = UserDB(user: user, in: context)
        coreDataManagerMock.stubbedFetchBlockResult = (userDB, ())
        
        // when
        var resUser: EasyService.User?
        accountService.getUser { result in
            switch result {
            case .success(let user):
                resUser = user
            case .failure:
                assertionFailure()
            }
        }
        
        // then
        XCTAssertTrue(authServiceMock.invokedUserIdGetter)
        XCTAssertTrue(coreDataManagerMock.invokedFetch)
        XCTAssertEqual(resUser?.identifier, user.identifier)
    }
    
    func test_getUserWithoutCurrentUserId() {
        // given
        
        // when
        var error: Error?
        accountService.getUser { res in
            guard case let .failure(er) = res else {
                assertionFailure()
                return
            }
            error = er
        }
        
        // then
        XCTAssertTrue(authServiceMock.invokedUserIdGetter)
        XCTAssertNotNil(error)
        assert((error as! NoneError) == NoneError.none)
        
    }
    
    func test_createUser() {
        // given
        let email = "aa@aa.ru"
        let password = "password"
        
        // when
        accountService.createUser(with: email, password: password) { _ in
            
        }
        
        // then
        XCTAssertTrue(authServiceMock.invokedCreateUser)
        XCTAssertEqual(authServiceMock.invokedCreateUserParameters?.email, email)
        XCTAssertEqual(authServiceMock.invokedCreateUserParameters?.password, password)
    }
    
    func test_signIn() {
        // given
        let email = "aa@aa.ru"
        let password = "password"
        
        // when
        accountService.signIn(with: email, password: password) { _ in
            
        }
        
        // then
        XCTAssertTrue(authServiceMock.invokedSignIn)
        XCTAssertEqual(authServiceMock.invokedSignInParameters?.email, email)
        XCTAssertEqual(authServiceMock.invokedSignInParameters?.password, password)
    }
    
    func test_signOut() throws {
        // given
        
        // when
        try accountService.signOut()
        
        // then
        XCTAssertTrue(authServiceMock.invokedSignOut)
    }
}
