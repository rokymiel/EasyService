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
    func fetch<T: NSFetchRequestResult & IModel> (request: NSFetchRequest<T>, _ block: @escaping (T?) -> Void)
    func count<T: NSFetchRequestResult>(request: NSFetchRequest<T>, _ block: @escaping (Int?) -> Void)
    func deleteAll<T: NSFetchRequestResult>(request: NSFetchRequest<T>)
}

class CoreDataManager: ICoreDataManager {
    private let coreDataStack: ICoreDatsStack
    private var taskExecutor: ITaskExecutor
    
    init(dataStack: ICoreDatsStack, taskExecutor: ITaskExecutor) {
        self.coreDataStack = dataStack
        self.taskExecutor = taskExecutor
        self.taskExecutor.queue = DispatchQueue(label: "corequeue", qos: .default, attributes: .concurrent)
        self.taskExecutor.async(flags: .barrier) {
            print(type(of: self.coreDataStack))
            self.coreDataStack.setupContainer()
        }
    }
    
    func save(model: IDBModel, _ block: (() -> Void)?) {
        self.taskExecutor.async {
            self.coreDataStack.perform { context in
                _ = model.toDBModel(in: context)
                _ = context.trySave()
                block?()
            }
        }
    }
    
    func fetchAll<T: NSFetchRequestResult> (request: NSFetchRequest<T>, _ block: @escaping ([T]?) -> Void) {
        self.taskExecutor.async {
            block(self.coreDataStack.fetch(request: request))
        }
    }
    
    func count<T: NSFetchRequestResult>(request: NSFetchRequest<T>, _ block: @escaping (Int?) -> Void) {
        self.taskExecutor.async {
            block(self.coreDataStack.count(request: request))
        }
    }
    
    func fetch<T: NSFetchRequestResult & IModel> (request: NSFetchRequest<T>, _ block: @escaping (T?) -> Void) {
        self.taskExecutor.async {
            block(self.coreDataStack.fetch(request: request)?.first)
        }
    }
    
    func deleteAll<T: NSFetchRequestResult>(request: NSFetchRequest<T>) {
        self.taskExecutor.async {
            self.coreDataStack.delete(request: request)
        }
    }
}
