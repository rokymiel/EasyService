//
//  ModelMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService

class ModelMock<T>: IModel {
    typealias DataType = T
    
    var invokedDataModelGetter = false
    var invokedDataModelGetterCount = 0
    var stubbedDataModel: DataType!
    
    var dataModel: DataType {
        invokedDataModelGetter = true
        invokedDataModelGetterCount += 1
        return stubbedDataModel
    }
}
