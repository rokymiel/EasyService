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
    var status: Status
    let timeOfWorks: Date?
    let typeOfWorks: String
    let serviceId: String
    
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
        case serviceId = "service_id"
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
        
        var text: String {
            switch self {
            case .denied: return "Отклонена"
            case .new: return "Новая"
            case .accepted: return "Принята"
            case .canceled: return "Отменена"
            case .inProgress: return "В работе"
            case .completed: return "Завершена"
            }
        }
        init?(numberValue: Int) {
            switch numberValue {
            case 0: self = .new
            case 1: self = .accepted
            case 2: self = .inProgress
            case 3: self = .completed
            default:
                return nil
            }
        }
        static let statusNumber = 4
        
        var color: UIColor {
            switch self {
            case .denied: return .systemRed
            case .canceled: return .gray
            case .new: return .systemYellow
            case .accepted: return .systemGreen
            case .inProgress: return .systemBlue
            case .completed: return .brown
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .denied, .canceled, .completed: return .white
            case .new, .accepted, .inProgress: return .black
            }
        }
    }
}
