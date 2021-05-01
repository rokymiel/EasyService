//
//  CoreDataManagerTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 01.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import XCTest
import CoreData

class CoreDataManagerTest: XCTestCase {
    var coreDatsStackMock: CoreDatsStackMock!
    var coreDataManager: ICoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDatsStackMock = CoreDatsStackMock()
        coreDataManager = CoreDataManager(dataStack: coreDatsStackMock)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDatsStackMock = nil
        coreDataManager = nil
    }
    
//    func test_save() {
//        // given
//        let didReceiveResponse = expectation(description: #function)
//        let context = NSManagedObjectContextMock()
//        coreDatsStackMock.stubbedPerformBlockResult = (context, ())
//        let model = DBModelMock()
//        
//        model.stubbedToDBModelResult = NSManagedObject(context: context)
//        
//        // when
//        coreDataManager.save(model: model) {
//            didReceiveResponse.fulfill()
//        }
//        
//        // then
//        wait(for: [didReceiveResponse], timeout: 0.01)
//        XCTAssertTrue(coreDatsStackMock.invokedSetupContainer)
//        XCTAssertTrue(coreDatsStackMock.invokedPerform)
//        XCTAssertTrue(model.invokedToDBModel)
//        assert(model.invokedToDBModelParameters?.context === context)
//        XCTAssertTrue(context.invokedSave)
//    }
    
    func test_fetchAll() {
        
    }
}
