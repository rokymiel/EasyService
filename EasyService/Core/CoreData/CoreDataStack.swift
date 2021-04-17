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
}

class CoreDataStack: ICoreDatsStack {
    private let dataBaseName = "Service"
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { _, error in
//            sleep(5)
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
            context.mergePolicy = NSOverwriteMergePolicy
            block(context)
        }
    }
    
    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>) -> [T]? {
//        let c = try? container.viewContext.fetch(request)
//        for a in c ?? []{
//            print(a as? UserDB)
//        }
//        print(c as? [T])
        print(try? container.viewContext.fetch(UserDB.fetchRequest()))
        return try? container.viewContext.fetch(request)
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
                self.rollback()
                return false
            }
        }
        return false
    }
}
