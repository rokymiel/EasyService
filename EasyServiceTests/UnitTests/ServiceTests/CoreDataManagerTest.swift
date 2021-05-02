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
    var taskExecutorMock: TaskExecutorMock!
    var coreDataManager: ICoreDataManager!
    
    override func setUp() {
        super.setUp()
        taskExecutorMock = TaskExecutorMock()
        coreDatsStackMock = CoreDatsStackMock()
        taskExecutorMock.shouldInvokeAsyncWork = true
        coreDataManager = CoreDataManager(dataStack: coreDatsStackMock, taskExecutor: taskExecutorMock)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDatsStackMock = nil
        coreDataManager = nil
        taskExecutorMock = nil
    }
    
    func test_save() {
        // given
        let context = NSManagedObjectContextMock()
        coreDatsStackMock.stubbedPerformBlockResult = (context, ())
        let model = DBModelMock()
        taskExecutorMock.shouldInvokeAsyncWork = true
        model.stubbedToDBModelResult = CarDB(context: context)

        // when
        coreDataManager.save(model: model) {
        }

        // then
        XCTAssertTrue(coreDatsStackMock.invokedSetupContainer)
        XCTAssertTrue(coreDatsStackMock.invokedPerform)
        XCTAssertTrue(taskExecutorMock.invokedAsync)
        XCTAssertEqual(taskExecutorMock.invokedAsyncCount, 2)
        XCTAssertTrue(model.invokedToDBModel)
        assert(model.invokedToDBModelParameters?.context === context)
        XCTAssertTrue(context.invokedSave)
    }
    
    func test_fetchAll() {
        // given
        let didReceiveResponse = expectation(description: #function)
        let context = NSManagedObjectContextMock()
        coreDatsStackMock.stubbedFetchResult = [CarDB(context: context), CarDB(context: context)]
        taskExecutorMock.shouldInvokeAsyncWork = true
        let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()

        // when
        var res: [CarDB]?
        coreDataManager.fetchAll(request: request) { result in
            didReceiveResponse.fulfill()
            res = result
        }

        // then
        wait(for: [didReceiveResponse], timeout: 0.01)
        XCTAssertTrue(coreDatsStackMock.invokedSetupContainer)
        XCTAssertTrue(coreDatsStackMock.invokedFetch)
        XCTAssertTrue(taskExecutorMock.invokedAsync)
        XCTAssertEqual(taskExecutorMock.invokedAsyncCount, 2)
        XCTAssertNotNil(res)
        XCTAssertEqual(coreDatsStackMock.stubbedFetchResult as? [CarDB], res)

    }
    
    func test_fetch() {
        // given
        let context = NSManagedObjectContextMock()
        let car1 = CarDB(context: context)
        let car2 = CarDB(context: context)
        coreDatsStackMock.stubbedFetchResult = [car1, car2]
        let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()
        taskExecutorMock.shouldInvokeAsyncWork = true

        // when
        var res: CarDB?
        coreDataManager.fetch(request: request) { result in
            res = result
        }

        // then
        XCTAssertTrue(coreDatsStackMock.invokedSetupContainer)
        XCTAssertTrue(coreDatsStackMock.invokedFetch)
        XCTAssertTrue(taskExecutorMock.invokedAsync)
        XCTAssertEqual(taskExecutorMock.invokedAsyncCount, 2)
        XCTAssertNotNil(res)
        XCTAssertEqual(car1, res)
    }
    
    func test_count() {
        // given
        coreDatsStackMock.stubbedCountResult = 5
        let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()
        taskExecutorMock.shouldInvokeAsyncWork = true

        // when
        var res: Int?
        coreDataManager.count(request: request) { result in
            res = result
        }

        // then
        XCTAssertTrue(coreDatsStackMock.invokedSetupContainer)
        XCTAssertTrue(coreDatsStackMock.invokedCount)
        XCTAssertTrue(taskExecutorMock.invokedAsync)
        XCTAssertEqual(taskExecutorMock.invokedAsyncCount, 2)
        XCTAssertNotNil(res)
        XCTAssertEqual(5, res)
    }
    
    func test_delete() {
        // given
        coreDatsStackMock.stubbedCountResult = 5
        let request: NSFetchRequest<CarDB> = CarDB.fetchRequest()

        // when
        coreDataManager.deleteAll(request: request)

        // then
        XCTAssertTrue(coreDatsStackMock.invokedSetupContainer)
        XCTAssertTrue(coreDatsStackMock.invokedDelete)
        XCTAssertTrue(taskExecutorMock.invokedAsync)
        XCTAssertEqual(taskExecutorMock.invokedAsyncCount, 2)
    }
    
}
