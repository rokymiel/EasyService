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
    var mileage: [Mileage]
    
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
    let isVerified: Bool
    enum CodingKeys: String, CodingKey {
        case date
        case value
        case isVerified = "is_verified"
    }
}

public class MileageX: NSObject, NSCoding {
    public func encode(with coder: NSCoder) {
        coder.encode(date, forKey: CodingKeys.date.rawValue)
        coder.encode(value, forKey: CodingKeys.value.rawValue)
        coder.encode(isVerified, forKey: CodingKeys.isVerified.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        guard let dDate = coder.decodeObject(forKey: CodingKeys.date.rawValue) as? Date else {
            return nil
        }
        let dValue = coder.decodeInt32(forKey: CodingKeys.value.rawValue)
        let dVer = coder.decodeBool(forKey: CodingKeys.isVerified.rawValue)
        self.init(date: dDate, value: dValue, isVerified: dVer)
    }
    
    let date: Date
    let value: Int32
    let isVerified: Bool
    
    enum CodingKeys: String {
        case date
        case value
        case isVerified = "is_verified"
    }
    
    init(date: Date, value: Int32, isVerified: Bool) {
        self.date = date
        self.value = value
        self.isVerified = isVerified
    }
}
