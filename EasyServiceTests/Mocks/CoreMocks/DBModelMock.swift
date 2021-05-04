//
//  DBModelMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import CoreData

class DBModelMock: IDBModel {
    
    var invokedToDBModel = false
    var invokedToDBModelCount = 0
    var invokedToDBModelParameters: (context: NSManagedObjectContext, Void)?
    var invokedToDBModelParametersList = [(context: NSManagedObjectContext, Void)]()
    var stubbedToDBModelResult: NSManagedObject!
    
    func toDBModel(in context: NSManagedObjectContext) -> NSManagedObject {
        invokedToDBModel = true
        invokedToDBModelCount += 1
        invokedToDBModelParameters = (context, ())
        invokedToDBModelParametersList.append((context, ()))
        return stubbedToDBModelResult
    }
}
