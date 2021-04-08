//
//  User.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Firebase

struct User {
    let identifier: String
    let name: String
    let surname: String
    let patronymic: String?
    let dateOfBirth: Date
    let phone: String
    let email: String
    let carIDs: [String]?
    let registrationsIDs: [String]?
}
