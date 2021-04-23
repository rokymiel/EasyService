//
//  DMExtensions.swift
//  EasyService
//
//  Created by Михаил on 14.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import CoreData

protocol IDBModel {
    func toDBModel(in context: NSManagedObjectContext) -> NSManagedObject
}

extension Array where Element == IDBModel {
    func toDBModels(in context: NSManagedObjectContext) -> [NSManagedObject] {
        self.map { $0.toDBModel(in: context) }
    }
}

protocol IModel {
    associatedtype DataType
    var dataModel: DataType { get }
}

extension UserDB: IModel {
    convenience init(user: User, in context: NSManagedObjectContext) {
        self.init(context: context)
        print("init1", user.identifier)
        identifier = user.identifier
        print("init2", identifier)
        name = user.name
        surname = user.surname
        patronymic = user.patronymic
        dateOfBirth = user.dateOfBirth
        phone = user.phone
        email = user.email
        carIDs = user.carIDs
        registrationsIDs = user.registrationsIDs
    }
    var dataModel: User {
        print("dataModel", identifier)
        return User(identifier: identifier,
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
    func toDBModel(in context: NSManagedObjectContext) -> NSManagedObject {
        UserDB(user: self, in: context)
    }
}
extension MileageDB: IModel {
    var dataModel: Mileage {
        Mileage(date: date!, value: Int(value), isVerified: isVerified)
    }
    
    convenience init(mileage: Mileage, of car: String, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.date = mileage.date
        self.value = Int32(mileage.value)
        self.isVerified = mileage.isVerified
        self.carId = car
    }
}

extension Mileage {
    func toDBModel(with car: String ,in context: NSManagedObjectContext) -> NSManagedObject {
        MileageDB(mileage: self, of: car, in: context)
    }
}

extension CarDB: IModel {
    convenience init(car: Car, in context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = car.identifier
        mark = car.mark
        model = car.model
        body = car.body
        gear = car.gear
        engine = car.engine
        productionYear = Int32(car.productionYear)
        if let id = car.identifier {
            car.mileage.forEach { mileage in
                if let model = mileage.toDBModel(with: id, in: context) as? MileageDB {
                    self.addToMileage(model)
                }
            }
        }
    }
    
    var dataModel: Car {
        Car(identifier: identifier,
            mark: mark!,
            model: model!,
            body: body!,
            gear: gear!,
            engine: engine,
            productionYear: Int(productionYear), mileage: mileage?.compactMap { mil in
                return (mil as? MileageDB)?.dataModel
            } ?? [])
    }
}

extension Car: IDBModel {
    func toDBModel(in context: NSManagedObjectContext) -> NSManagedObject {
        CarDB(car: self, in: context)
    }
}

extension RegistrationDB: IModel {
    convenience init(registration: Registration, in context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = registration.identifier
        carID = registration.carID
        clientID = registration.clientID
        cost = nil
        if let reCost = registration.cost {
            cost = NSNumber(value: reCost)
        }
        dateOfCreation = registration.dateOfCreation
        dateOfRegistration = registration.dateOfRegistration
        descriptionString = registration.description
        notes = registration.notes
        status = registration.status.rawValue
        timeOfWorks = registration.timeOfWorks
        typeOfWorks = registration.typeOfWorks
        serviceId = registration.serviceId
    }
    var dataModel: Registration {
        var dCost: Double?
        if let cost = cost {
            dCost = Double(exactly: cost)
        }
        return Registration(identifier: identifier,
                     carID: carID!,
                     clientID: clientID!,
                     cost: dCost,
                     dateOfCreation: dateOfCreation!,
                     dateOfRegistration: dateOfRegistration!,
                     description: descriptionString,
                     notes: notes,
                     status: .init(rawValue: status!),
                     timeOfWorks: timeOfWorks,
                     typeOfWorks: typeOfWorks!, serviceId: serviceId!)
    }
}

extension Registration: IDBModel {
    func toDBModel(in context: NSManagedObjectContext) -> NSManagedObject {
        RegistrationDB(registration: self, in: context)
    }
}
