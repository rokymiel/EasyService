//
//  LocalDictionary.swift
//  EasyService
//
//  Created by Михаил on 20.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

protocol ILocalDictionary {
    func set(_ value: Any, for key: String)
    func get(_ key: String) -> Any?
    func remove(_ key: String)
}

class LocalDictionary: ILocalDictionary {
    private let userDefaults: UserDefaults
    
    init() {
        userDefaults = UserDefaults.standard
    }
    
    func set(_ value: Any, for key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func get(_ key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
    
    func remove(_ key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
