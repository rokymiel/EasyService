//
//  LocalDictionaryMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 29.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService

class LocalDictionaryMock: ILocalDictionary {

    var invokedSet = false
    var invokedSetCount = 0
    var invokedSetParameters: (value: Any, key: String)?
    var invokedSetParametersList = [(value: Any, key: String)]()

    func set(_ value: Any, for key: String) {
        invokedSet = true
        invokedSetCount += 1
        invokedSetParameters = (value, key)
        invokedSetParametersList.append((value, key))
    }

    var invokedGet = false
    var invokedGetCount = 0
    var invokedGetParameters: (key: String, Void)?
    var invokedGetParametersList = [(key: String, Void)]()
    var stubbedGetResult: Any!

    func get(_ key: String) -> Any? {
        invokedGet = true
        invokedGetCount += 1
        invokedGetParameters = (key, ())
        invokedGetParametersList.append((key, ()))
        return stubbedGetResult
    }

    var invokedRemove = false
    var invokedRemoveCount = 0
    var invokedRemoveParameters: (key: String, Void)?
    var invokedRemoveParametersList = [(key: String, Void)]()

    func remove(_ key: String) {
        invokedRemove = true
        invokedRemoveCount += 1
        invokedRemoveParameters = (key, ())
        invokedRemoveParametersList.append((key, ()))
    }
}
