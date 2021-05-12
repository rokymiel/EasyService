//
//  UserFake.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import Foundation

extension User {
    static func fake(identifier: String,
                     name: String? = nil,
                     surname: String? = nil,
                     patronymic: String? = nil,
                     dateOfBirth: Date? = nil,
                     phone: String? = nil,
                     email: String? = nil) -> User {
        User(identifier: identifier,
             name: name ?? "John",
             surname: surname ?? "Bro",
             patronymic: patronymic ?? "Daiton",
             dateOfBirth: dateOfBirth ?? Date(),
             phone: phone ?? "98988898",
             email: email ?? "aa@aa.com")
    }
}
