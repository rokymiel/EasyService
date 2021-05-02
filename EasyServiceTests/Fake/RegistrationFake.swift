//
//  RegistrationFake.swift
//  EasyServiceTests
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import Foundation

extension Registration {
    static func fake(identifier: String,
                     carID: String? = nil,
                     clientID: String? = nil,
                     cost: Double? = nil,
                     dateOfCreation: Date? = nil,
                     dateOfRegistration: Date? = nil,
                     description: String? = nil,
                     notes: String? = nil,
                     status: Status? = nil,
                     timeOfWorks: Date? = nil,
                     typeOfWorks: String? = nil,
                     serviceId: String? = nil) -> Registration {
        Registration(identifier: identifier,
              carID: carID ?? "CAR_ID",
              clientID: clientID ?? "CLIENT_ID",
              cost: cost ?? 999,
              dateOfCreation: dateOfCreation ?? Date(timeIntervalSince1970: 0),
              dateOfRegistration: dateOfRegistration ?? Date(timeIntervalSince1970: 0),
              description: description ?? "QWERTYYU",
              notes: notes ?? "It's my notes",
              status: status ?? .new,
              timeOfWorks: timeOfWorks ?? Date(timeIntervalSince1970: 0),
              typeOfWorks: typeOfWorks ?? "ТО",
              serviceId: serviceId ?? "SERVICE_ID")
    }
}
