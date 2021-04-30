//
//  CoreDataStack.swift
//  EasyService
//
//  Created by Михаил on 14.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol ICoreDatsStack {
    var container: NSPersistentContainer { get }
    func getViewContext() -> NSManagedObjectContext
    
    func perform(_ block: @escaping (NSManagedObjectContext) -> Void )
    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>) -> [T]?
    func count(request: NSFetchRequest<NSFetchRequestResult>) -> Int?
    func delete<T: NSFetchRequestResult> (request: NSFetchRequest<T>)
}

class CoreDataStack: ICoreDatsStack {
    private let dataBaseName = "Service"
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { desc, error in
            desc.shouldMigrateStoreAutomatically = false
            print("Done")
//            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
//        self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
        
    }()
    
    func getViewContext() -> NSManagedObjectContext {
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container.viewContext
    }
    
    func perform(_ block: @escaping (NSManagedObjectContext) -> Void ) {
        container.performBackgroundTask { (context) in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy //NSOverwriteMergePolicy
            block(context)
        }
    }
    
    func count(request: NSFetchRequest<NSFetchRequestResult>) -> Int? {
        return try? container.viewContext.count(for: request)
    }
    
    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>) -> [T]? {
//        let c = try? container.viewContext.fetch(request)
//        for a in c ?? []{
//            print(a as? UserDB)
//        }
//        print(c as? [T])
//        let f: NSFetchRequest<UserDB> = UserDB.fetchRequest()
//        let a = try? container.viewContext.fetch(f).first
//        print("CREmail", a?.email)
//        print("CRE", a)
//        print("CREid", a?.identifier)
        request.returnsObjectsAsFaults = false
        return try? container.viewContext.fetch(request)
    }
    
    func delete<T: NSFetchRequestResult> (request: NSFetchRequest<T>) {
        perform { context in
            request.returnsObjectsAsFaults = false
            do {
                 let results = try context.fetch(request)
                 for object in results {
                     guard let objectData = object as? NSManagedObject else {continue}
                     context.delete(objectData)
                 }
               context.trySave()
                
             } catch {
                 NSLog("Не удалось удалить данные из БД: \(error)")
             }
        }

    }
}

extension NSManagedObjectContext {
    func trySave() -> Bool {
        if self.hasChanges {
            do {
                print("TrySave")
                try self.save()
                return true
            } catch {
                print("AAAAAAAAAASUKA",error)
                print(error.localizedDescription)
                print(self)
                self.rollback()
                return false
            }
        }
        return false
    }
}
