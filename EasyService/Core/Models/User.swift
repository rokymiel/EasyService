//
//  User.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var identifier: String?
    let name: String
    let surname: String
    let patronymic: String?
    let dateOfBirth: Date
    let phone: String
    let email: String
    var carIDs = [String]()
    var registrationsIDs = [String]()
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case name
        case surname
        case patronymic
        case dateOfBirth = "date_of_birth"
        case phone
        case email
    }
}
