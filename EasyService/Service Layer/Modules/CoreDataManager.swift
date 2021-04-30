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
    func save(model: IDBModel, _ block: (() -> Void)?)
    func fetchAll<T: NSFetchRequestResult> (request: NSFetchRequest<T>, _ block: @escaping ([T]?) -> Void)
    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>, _ block: @escaping (T?) -> Void)
    func count<T: NSFetchRequestResult>(request: NSFetchRequest<T>, _ block: @escaping (Int?) -> Void)
    func deleteAll<T: NSFetchRequestResult>(request: NSFetchRequest<T>)
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
    
    func save(model: IDBModel, _ block: (() -> Void)?) {
        queue.async {
            self.coreDataStack.perform { context in
                _ = model.toDBModel(in: context)
                _ = context.trySave()
                block?()
            }
        }
    }
    
    func fetchAll<T: NSFetchRequestResult> (request: NSFetchRequest<T>, _ block: @escaping ([T]?) -> Void) {
        queue.async {
            block(self.coreDataStack.fetch(request: request))
        }
    }
    
    func count<T: NSFetchRequestResult>(request: NSFetchRequest<T>, _ block: @escaping (Int?) -> Void) {
        queue.async {
            block(self.coreDataStack.count(request: request))
        }
    }
    
    func fetch<T: NSFetchRequestResult> (request: NSFetchRequest<T>, _ block: @escaping (T?) -> Void) {
        queue.async {
            block(self.coreDataStack.fetch(request: request)?.first)
        }
    }
    
    func deleteAll<T: NSFetchRequestResult>(request: NSFetchRequest<T>) {
        queue.async {
            self.coreDataStack.delete(request: request)
        }
    }
}
