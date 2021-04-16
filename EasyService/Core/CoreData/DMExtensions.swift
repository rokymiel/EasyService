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
    var user: User {
        User(identifier: identifier,
             name: name!,
             surname: surname!,
             patronymic: patronymic,
             dateOfBirth: dateOfBirth!,
             phone: phone!,
             email: email!,
             carIDs: carIDs!,
             registrationsIDs: registrationsIDs!)
    }
}

extension User: IDBModel {
    func toModel(in context: NSManagedObjectContext) -> NSManagedObject {
        UserDB(user: self, in: context)
    }
}

extension CarDB {
    convenience init(car: Car, in context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = car.identifier
        mark = car.mark
        model = car.model
        body = car.body
        gear = car.gear
        engine = car.engine
        productionYear = Int32(car.productionYear)
    }
    
    var car: Car {
        Car(identifier: identifier,
            mark: mark!,
            model: model!,
            body: body!,
            gear: gear!,
            engine: engine,
            productionYear: Int(productionYear))
    }
}

extension Car: IDBModel {
    func toModel(in context: NSManagedObjectContext) -> NSManagedObject {
        CarDB(car: self, in: context)
    }
}

extension RegistrationDB {
    convenience init(registration: Registration, in context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = registration.identifier
        carID = registration.carID
        clientID = registration.clientID
        cost = nil
        if let reCost = registration.cost {
            cost = NSNumber(value: reCost)
        }
        dateOfCreation = registration.dateOfCreation.dateValue()
        dateOfRegistration = registration.dateOfRegistration.dateValue()
        descriptionString = registration.description
        notes = registration.notes
        status = registration.status.rawValue
        timeOfWorks = registration.timeOfWorks?.dateValue()
        typeOfWorks = registration.typeOfWorks
    }
}

extension Registration: IDBModel {
    func toModel(in context: NSManagedObjectContext) -> NSManagedObject {
        RegistrationDB(registration: self, in: context)
    }
}
