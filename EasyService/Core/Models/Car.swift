//
//  Car.swift
//  EasyService
//
//  Created by Михаил on 10.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import FirebaseFirestoreSwift

struct Car: Codable {
    @DocumentID var identifier: String?
    
    let mark: String
    let model: String
    let body: String
    let gear: String
    let engine: Double
    let productionYear: Int
    let mileage: [Mileage]
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case mark
        case model
        case body
        case gear
        case engine
        case productionYear = "production_year"
        case mileage
    }
}

struct Mileage: Codable {
    let date: Date
    let value: Int
    enum CodingKeys: String, CodingKey {
        case date
        case value
    }
}
