//
//  WeakRef.swift
//  EasyService
//
//  Created by Михаил on 23.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//
import Foundation
class WeakRef<T> where T: AnyObject {

    private(set) weak var value: T?

    init(value: T?) {
        self.value = value
    }
}
