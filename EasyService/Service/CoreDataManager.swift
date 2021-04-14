//
//  CoreDataManager.swift
//  EasyService
//
//  Created by Михаил on 14.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//
import Foundation
import CoreData

protocol ICoreDataManager {
    func save(model: IDBModel, _ block: (()-> Void)?)
    func fetchAll<T: NSManagedObject> (_ item: T.Type, _ block: @escaping ([T]?) -> Void)
}

class CoreDataManager: ICoreDataManager {
    private let coreDataStack: ICoreDatsStack
    let queue = DispatchQueue(label: "corequeue", qos: .default, attributes: .concurrent)
    init(dataStack: ICoreDatsStack) {
        self.coreDataStack = dataStack
        queue.async(flags: .barrier) {
            _ = self.coreDataStack.container
        }
    }
    
    func save(model: IDBModel, _ block: (()-> Void)?) {
        queue.async {
            self.coreDataStack.perform { context in
                _ = model.toModel(in: context)
                _ = context.trySave()
                block?()
            }
        }
    }
    
    func fetchAll<T: NSManagedObject> (_ item: T.Type, _ block: @escaping ([T]?) -> Void) {
        queue.async {
            block(self.coreDataStack.fetch(type: item, request: item.fetchRequest()))
        }
    }
}
