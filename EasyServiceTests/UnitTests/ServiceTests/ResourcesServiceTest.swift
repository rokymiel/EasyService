//
//  ResourcesServiceTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 01.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import XCTest

class ResourcesServiceTest: XCTestCase {
    var resourcesService: IResourcesService!
    var resourcesMock: ResourcesMock!
    
    override func setUp() {
        super.setUp()
        
        resourcesMock = ResourcesMock()
        resourcesService = ResourcesService(resources: resourcesMock)
    }
    
    override func tearDown() {
        super.tearDown()
        resourcesMock = nil
        resourcesService = nil
    }
    
    func test_getCars() {
        // given
        resourcesMock.stubbedGetDataResult = carsData()
        
        // when
        let carList = resourcesService.getCars()
        
        // then
        XCTAssertNotNil(carList)
        XCTAssertTrue(resourcesMock.invokedGetData)
        XCTAssertEqual(["AC": ["378 GT Zagato"], "Acura": ["CL"]], carList)
        XCTAssertEqual(resourcesMock.invokedGetDataParameters?.forResource, "cars")
        XCTAssertEqual(resourcesMock.invokedGetDataParameters?.withExtension, "json")
    }
    
    func test_getGears() {
        // given
        resourcesMock.stubbedGetDataResult = strings()
        
        // when
        let res = resourcesService.getGears()
        
        // then
        XCTAssertNotNil(res)
        XCTAssertTrue(resourcesMock.invokedGetData)
        XCTAssertEqual(["First", "Second"], res)
        XCTAssertEqual(resourcesMock.invokedGetDataParameters?.forResource, "gears")
        XCTAssertEqual(resourcesMock.invokedGetDataParameters?.withExtension, "json")
    }
    
    func test_getCarsBodies() {
        // given
        resourcesMock.stubbedGetDataResult = strings()
        
        // when
        let res = resourcesService.getCarsBodies()
        
        // then
        XCTAssertNotNil(res)
        XCTAssertTrue(resourcesMock.invokedGetData)
        XCTAssertEqual(["First", "Second"], res)
        XCTAssertEqual(resourcesMock.invokedGetDataParameters?.forResource, "carsBodies")
        XCTAssertEqual(resourcesMock.invokedGetDataParameters?.withExtension, "json")
    }
    
    func carsData() -> Data {
        "{\"AC\": [\"378 GT Zagato\"], \"Acura\": [ \"CL\" ]}".data(using: .utf8)!
    }
    func strings() -> Data {
        "[\"First\", \"Second\"]".data(using: .utf8)!
    }
}
