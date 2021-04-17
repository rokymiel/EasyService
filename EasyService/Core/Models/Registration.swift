//
//  Registration.swift
//  EasyService
//
//  Created by Михаил on 14.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import FirebaseFirestoreSwift
import Firebase
struct Registration: Codable {
    @DocumentID var identifier: String?
    let carID: String
    let clientID: String
    let cost: Double?
    let dateOfCreation: Date
    let dateOfRegistration: Date
    let description: String?
    let notes: String?
    let status: Status
    let timeOfWorks: Date?
    let typeOfWorks: String
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case carID = "car_id"
        case clientID = "client_id"
        case cost
        case dateOfCreation = "date_of_creation"
        case dateOfRegistration = "date_of_registration"
        case description
        case notes
        case status
        case timeOfWorks = "time_of_works"
        case typeOfWorks = "type_of_works"
    }
    
    enum Status: String, Codable {
        case denied
        case new
        case accepted
        case canceled
        case inProgress = "in_progress"
        case completed
        
        init(rawValue: String) {
            switch rawValue {
            case "denied": self = .denied
            case "new": self = .new
            case "accepted": self = .accepted
            case "canceled": self = .canceled
            case "in_progress" : self = .inProgress
            case "completed": self = .completed
            default: self = .new
            }
        }
    }
}
