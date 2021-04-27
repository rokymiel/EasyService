//
//  ResourcesService.swift
//  EasyService
//
//  Created by Михаил on 10.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IResourcesService {
    func getCars() -> [String: [String]]?
    func getGears() -> [String]?
    func getCarsBodies() -> [String]?
}

class ResourcesService: IResourcesService {
    
    private let resources: IResources
    
    init(resources: IResources) {
        self.resources = resources
    }
    
    func getCars() -> [String: [String]]? {
        if let data = resources.getData(forResource: "cars", withExtension: "json"),
           let json = try? JSON(data: data) {
            // use path
            var cars: [String: [String]] = [:]
            for car in json {
                if let models = car.1.arrayObject as? [String] {
                    cars[car.0] = models
                }
            }
            return cars
        }
        return nil
    }
    
    func getGears() -> [String]? {
        if let data = resources.getData(forResource: "gears", withExtension: "json"),
           let json = try? JSON(data: data) {
            // use path
            return json.arrayObject as? [String]
        }
        return nil
    }
    
    func getCarsBodies() -> [String]? {
        if let data = resources.getData(forResource: "carsBodies", withExtension: "json"),
           let json = try? JSON(data: data) {
            // use path
            return json.arrayObject as? [String]
        }
        return nil
    }
    
}
