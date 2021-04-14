//
//  DMExtensions.swift
//  EasyService
//
//  Created by Михаил on 14.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import CoreData

protocol IDBModel {
    func toModel(in context: NSManagedObjectContext) -> NSManagedObject
}

extension UserDB {
//    typealias T = UserDB
    convenience init(user: User, in context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = user.identifier
        name = user.name
        surname = user.surname
        patronymic = user.patronymic
        dateOfBirth = user.dateOfBirth
        phone = user.phone
        email = user.email
        carIDs = user.carIDs
        registrationsIDs = user.registrationsIDs
    }
}

extension User: IDBModel {
    func toModel(in context: NSManagedObjectContext) -> NSManagedObject {
        UserDB(user: self, in: context)
    }
}

