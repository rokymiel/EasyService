//
//  TaskExecutorMock.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService
import Foundation

class TaskExecutorMock: ITaskExecutor {
    
    var invokedQueueSetter = false
    var invokedQueueSetterCount = 0
    var invokedQueue: DispatchQueue?
    var invokedQueueList = [DispatchQueue]()
    var invokedQueueGetter = false
    var invokedQueueGetterCount = 0
    var stubbedQueue: DispatchQueue!
    
    var queue: DispatchQueue {
        get {
            invokedQueueGetter = true
            invokedQueueGetterCount += 1
            return stubbedQueue
        }
        set {
            invokedQueueSetter = true
            invokedQueueSetterCount += 1
            invokedQueue = newValue
            invokedQueueList.append(newValue)
        }
    }
    
    var invokedAsync = false
    var invokedAsyncCount = 0
    var invokedAsyncParameters: (group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags)?
    var invokedAsyncParametersList = [(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags)]()
    var shouldInvokeAsyncWork = false
    
    func async(group: DispatchGroup?,
               qos: DispatchQoS,
               flags: DispatchWorkItemFlags,
               execute work: @escaping () -> Void) {
        invokedAsync = true
        invokedAsyncCount += 1
        invokedAsyncParameters = (group, qos, flags)
        invokedAsyncParametersList.append((group, qos, flags))
        if shouldInvokeAsyncWork {
            work()
        }
    }
    
    var invokedSync = false
    var invokedSyncCount = 0
    var shouldInvokeSyncWork = false
    
    func sync(execute work: @escaping () -> Void) {
        invokedSync = true
        invokedSyncCount += 1
        if shouldInvokeSyncWork {
            work()
        }
    }
}
