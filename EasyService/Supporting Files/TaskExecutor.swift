//
//  TaskExecutor.swift
//  EasyService
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

protocol ITaskExecutor {
    func async(group: DispatchGroup?,
               qos: DispatchQoS,
               flags: DispatchWorkItemFlags,
               execute work: @escaping () -> Void)
    func sync(execute work: @escaping () -> Void)
    var queue: DispatchQueue { get set }
}

extension ITaskExecutor {
    func async(group: DispatchGroup? = nil,
               qos: DispatchQoS = .unspecified,
               flags: DispatchWorkItemFlags = [],
               execute work: @escaping () -> Void) {
        async(group: group, qos: qos, flags: flags, execute: work)
    }
}

class TaskExecutor: ITaskExecutor {
    
    init(_ queue: DispatchQueue? = nil) {
        self.queue = queue ?? .global()
    }
        
    func async(group: DispatchGroup? = nil,
               qos: DispatchQoS = .unspecified,
               flags: DispatchWorkItemFlags = [],
               execute work: @escaping () -> Void) {
        queue.async(group: group, qos: qos, flags: flags, execute: work)
    }
    
    func sync(execute work: @escaping () -> Void) {
        queue.sync {
            work()
        }
    }
    
    var queue: DispatchQueue
    
}
