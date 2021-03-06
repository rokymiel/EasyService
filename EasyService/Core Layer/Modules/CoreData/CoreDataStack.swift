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
    func setupContainer()
    func perform(_ block: @escaping (NSManagedObjectContext) -> Void )
    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>) -> [T]?
    func count<T: NSFetchRequestResult>(request: NSFetchRequest<T>) -> Int?
    func delete<T: NSFetchRequestResult> (request: NSFetchRequest<T>)
}

class CoreDataStack: ICoreDatsStack {
    private let dataBaseName = "Service"
    // Здесь можно сделать статический метод configure, который
    // создает экземпляр и настраивает контейнер
    // Пример Firestore.firestore()
    private(set) lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { desc, error in
            desc.shouldMigrateStoreAutomatically = false
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func setupContainer() {
        _ = container
    }
    
    func getViewContext() -> NSManagedObjectContext {
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container.viewContext
    }
    
    func perform(_ block: @escaping (NSManagedObjectContext) -> Void ) {
        container.performBackgroundTask { (context) in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
        }
    }
    
    func count<T: NSFetchRequestResult>(request: NSFetchRequest<T>) -> Int? {
        return try? container.viewContext.count(for: request)
    }
    
    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>) -> [T]? {
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
                _ = context.trySave()
                
            } catch {
                NSLog("Не удалось удалить данные из БД: \(error)")
            }
        }
        
    }
}

extension NSManagedObjectContext {
    @objc func trySave() -> Bool {
        if self.hasChanges {
            do {
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
