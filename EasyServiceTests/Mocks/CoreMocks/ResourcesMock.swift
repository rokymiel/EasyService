//
//  ResourcesMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 29.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import Foundation

class ResourcesMock: IResources {

    var invokedGetData = false
    var invokedGetDataCount = 0
    var invokedGetDataParameters: (forResource: String, withExtension: String)?
    var invokedGetDataParametersList = [(forResource: String, withExtension: String)]()
    var stubbedGetDataResult: Data!

    func getData(forResource: String, withExtension: String) -> Data? {
        invokedGetData = true
        invokedGetDataCount += 1
        invokedGetDataParameters = (forResource, withExtension)
        invokedGetDataParametersList.append((forResource, withExtension))
        return stubbedGetDataResult
    }
}
