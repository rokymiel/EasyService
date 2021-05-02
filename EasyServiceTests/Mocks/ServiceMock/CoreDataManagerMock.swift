//
//  CoreDataManagerMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import CoreData

class CoreDataManagerMock: ICoreDataManager {

    var invokedSave = false
    var invokedSaveCount = 0
    var invokedSaveParameters: (model: IDBModel, Void)?
    var invokedSaveParametersList = [(model: IDBModel, Void)]()
    var shouldInvokeSaveBlock = false

    func save(model: IDBModel, _ block: (() -> Void)?) {
        invokedSave = true
        invokedSaveCount += 1
        invokedSaveParameters = (model, ())
        invokedSaveParametersList.append((model, ()))
        if shouldInvokeSaveBlock {
            block?()
        }
    }

    var invokedFetchAll = false
    var invokedFetchAllCount = 0
    var invokedFetchAllParameters: (request: AnyObject, Void)?
    var invokedFetchAllParametersList = [(request: AnyObject, Void)]()
    var stubbedFetchAllBlockResult: ([Any]?, Void)?

    func fetchAll<T: NSFetchRequestResult> (request: NSFetchRequest<T>, _ block: @escaping ([T]?) -> Void) {
        invokedFetchAll = true
        invokedFetchAllCount += 1
        invokedFetchAllParameters = (request, ())
        invokedFetchAllParametersList.append((request, ()))
        if let result = stubbedFetchAllBlockResult {
            block(result.0 as? [T])
        }
    }

    var invokedFetch = false
    var invokedFetchCount = 0
    var invokedFetchParameters: (request: AnyObject, Void)?
    var invokedFetchParametersList = [(request: AnyObject, Void)]()
    var stubbedFetchBlockResult: (Any?, Void)?

    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>, _ block: @escaping (T?) -> Void) {
        invokedFetch = true
        invokedFetchCount += 1
        invokedFetchParameters = (request, ())
        invokedFetchParametersList.append((request, ()))
        if let result = stubbedFetchBlockResult {
            block(result.0 as? T)
        }
    }

    var invokedCount = false
    var invokedCountCount = 0
    var invokedCountParameters: (request: AnyObject, Void)?
    var invokedCountParametersList = [(request: AnyObject, Void)]()
    var stubbedCountBlockResult: (Int?, Void)?

    func count<T: NSFetchRequestResult>(request: NSFetchRequest<T>, _ block: @escaping (Int?) -> Void) {
        invokedCount = true
        invokedCountCount += 1
        invokedCountParameters = (request, ())
        invokedCountParametersList.append((request, ()))
        if let result = stubbedCountBlockResult {
            block(result.0)
        }
    }

    var invokedDeleteAll = false
    var invokedDeleteAllCount = 0
    var invokedDeleteAllParameters: (request: AnyObject, Void)?
    var invokedDeleteAllParametersList = [(request: AnyObject, Void)]()

    func deleteAll<T: NSFetchRequestResult>(request: NSFetchRequest<T>) {
        invokedDeleteAll = true
        invokedDeleteAllCount += 1
        invokedDeleteAllParameters = (request, ())
        invokedDeleteAllParametersList.append((request, ()))
    }
}
