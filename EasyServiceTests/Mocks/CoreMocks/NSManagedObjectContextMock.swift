//
//  NSManagedObjectContextMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//
@testable import EasyService
import CoreData

class NSManagedObjectContextMock: NSManagedObjectContext {
    init() {
        super.init(concurrencyType: .mainQueueConcurrencyType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var invokedSave = false
    var invokedSaveCount = 0
    var stubbedSaveResult: Bool = false
    override func trySave() -> Bool {
        invokedSave = true
        invokedSaveCount += 1
        return stubbedSaveResult
    }
}

extension NSManagedObjectContext {
    
}
