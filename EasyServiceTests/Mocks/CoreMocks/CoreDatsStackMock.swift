//
//  CoreDatsStackMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 29.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import CoreData

class CoreDatsStackMock: ICoreDatsStack {

    var invokedContainerGetter = false
    var invokedContainerGetterCount = 0
    var stubbedContainer: NSPersistentContainer!

    var container: NSPersistentContainer {
        invokedContainerGetter = true
        invokedContainerGetterCount += 1
        return stubbedContainer
    }

    var invokedGetViewContext = false
    var invokedGetViewContextCount = 0
    var stubbedGetViewContextResult: NSManagedObjectContext!

    func getViewContext() -> NSManagedObjectContext {
        invokedGetViewContext = true
        invokedGetViewContextCount += 1
        return stubbedGetViewContextResult
    }

    var invokedPerform = false
    var invokedPerformCount = 0
    var stubbedPerformBlockResult: (NSManagedObjectContext, Void)?

    func perform(_ block: @escaping (NSManagedObjectContext) -> Void ) {
        invokedPerform = true
        invokedPerformCount += 1
        if let result = stubbedPerformBlockResult {
            block(result.0)
        }
    }

    var invokedFetch = false
    var invokedFetchCount = 0
    var invokedFetchParameters: (request: Any, Void)?
    var invokedFetchParametersList = [(request: Any, Void)]()
    var stubbedFetchResult: [Any]!

    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>) -> [T]? {
        invokedFetch = true
        invokedFetchCount += 1
        invokedFetchParameters = (request, ())
        invokedFetchParametersList.append((request, ()))
        return stubbedFetchResult as? [T]
    }

    var invokedCount = false
    var invokedCountCount = 0
    var invokedCountParameters: (request: NSFetchRequest<NSFetchRequestResult>, Void)?
    var invokedCountParametersList = [(request: NSFetchRequest<NSFetchRequestResult>, Void)]()
    var stubbedCountResult: Int!

    func count(request: NSFetchRequest<NSFetchRequestResult>) -> Int? {
        invokedCount = true
        invokedCountCount += 1
        invokedCountParameters = (request, ())
        invokedCountParametersList.append((request, ()))
        return stubbedCountResult
    }

    var invokedDelete = false
    var invokedDeleteCount = 0
    var invokedDeleteParameters: (request: Any, Void)?
    var invokedDeleteParametersList = [(request: Any, Void)]()

    func delete<T: NSFetchRequestResult> (request: NSFetchRequest<T>) {
        invokedDelete = true
        invokedDeleteCount += 1
        invokedDeleteParameters = (request, ())
        invokedDeleteParametersList.append((request, ()))
    }
}
